output "aws_instance_public_dns" {
    value = aws_instance.ec2_nginx1.public_dns
}