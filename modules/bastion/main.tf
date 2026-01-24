


resource "aws_ec2_host" "bastion_host" {
  instance_type = var.instance_type
  for_each = var.availability_zone
  availability_zone = each.value
  auto_placement = "on"
}