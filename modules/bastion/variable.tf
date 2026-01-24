variable "availability_zone" {
  type = list(string)
  description = "The availability zone for the bastion host"
}

variable "instance_type" {
  type = string
  description = "The instance type for the bastion host"
}