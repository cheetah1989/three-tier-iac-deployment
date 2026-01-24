# 1. VPC & Internet Gateway
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# 2. Public Subnets (Iterating over a map of AZ to CIDR)
resource "aws_subnet" "public" {
  for_each = zipmap(var.azs, var.public_subnet_cidrs)

  vpc_id            = aws_vpc.main.id
  availability_zone = each.key
  cidr_block        = each.value
  map_public_ip_on_launch = true

  tags = { Name = "public-${each.key}" }
}

# 3. Private Subnets
resource "aws_subnet" "private" {
  for_each = zipmap(var.azs, var.private_subnet_cidrs)

  vpc_id            = aws_vpc.main.id
  availability_zone = each.key
  cidr_block        = each.value

  tags = { Name = "private-${each.key}" }
}

# 4. NAT Gateway (One for each AZ to prevent single points of failure)
resource "aws_eip" "nat" {
  for_each   = aws_subnet.public
  domain     = "vpc"
}

resource "aws_nat_gateway" "nat" {
  for_each      = aws_subnet.public
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = each.value.id
}


# Public Routing
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Private Routing (One table per AZ to map to its specific NAT GW)
resource "aws_route_table" "private" {
  for_each = aws_subnet.private
  vpc_id   = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[each.key].id
  }
}

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}
