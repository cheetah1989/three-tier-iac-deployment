output "bastion_host_ip" {
  value = aws_ec2_host.bastion_host.public_ip
}