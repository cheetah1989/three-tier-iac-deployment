variable "azs" {
  type        = list(string)
  description = "List of availability zones, e.g., ['us-east-1a', 'us-east-1b']"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for public subnets"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for private subnets"
}
variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}