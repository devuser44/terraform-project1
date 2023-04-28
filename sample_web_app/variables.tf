variable "aws_access_key" {
  type = string  
  description = "aws access key"
  sensitive = true
}

variable "aws_secret_key" {
    type = string
    description = "aws secret key"
    sensitive = true
}

variable "aws_region" {
    type = string
    description = "aws region to be used for resources"
    default = "us-east-1"
}

variable "enable_dns_hostnames" {
  type = bool
  description = "Enable DNS hostnames in VPC"
  default = true
}

variable "vpc_cidr_block" {
    type = string
    description = "base cidr block for VPC"
    default = "10.0.0.0/16"
}

variable "vpc_subnet1_cidr_block" {
    type = string
    description = "base cidr block for subnet 1 in VPC"
    default = "10.0.0.0/24"
}

variable "map_public_ip_on_launch" {
    type = bool
    description = "Map a public IP address for subnet instances"
    default = true
}
variable "instance_type" {
  type = string
  description = "Type for EC2 instance"  
  default = "t2.micro"
}
variable "company" {
  type = string
  description = "name of company"
  default = "test company"
}
variable "project" {
  type = string
  description = "name of project"
}
variable "billing_code" {
  type = string
  description = "billing code"
}