### Providers
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.aws_region
}
### Data
data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

### Resources

# Networking

resource "aws_vpc" "sample_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = local.common_tags
}

resource "aws_internet_gateway" "sample_igw" {
  vpc_id = aws_vpc.sample_vpc.id  
  tags = local.common_tags
}
  
resource "aws_subnet" "sample_subnet1" {
  cidr_block = var.vpc_subnet1_cidr_block
  vpc_id = aws_vpc.sample_vpc.id
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags = local.common_tags
}

# Routing
resource "aws_route_table" "sample_route_table" {
  vpc_id = aws_vpc.sample_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sample_igw.id
  }
  tags = local.common_tags
}

resource "aws_route_table_association" "sample_route_tbl_assoc" {
  subnet_id = aws_subnet.sample_subnet1.id
  route_table_id = aws_route_table.sample_route_table.id
}

# Security Groups 
# Nginx security group
resource "aws_security_group" "nginx_sg" {
  name = "nginx_sg"
  vpc_id = aws_vpc.sample_vpc.id

  # http access from anywhere
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow outbound internet access 
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.common_tags
}

# Instances
resource "aws_instance" "ec2_nginx1" {
  ami = data.aws_ssm_parameter.ami.value
  instance_type = var.instance_type
  subnet_id = aws_subnet.sample_subnet1.id
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]

  user_data = <<EOF
    #!/bin/bash
    sudo amazon-linux-extras install -y nginx1
    sudo service nginx start
    sudo rm /usr/share/nginx/html/index.html
    echo '<html><head><title>Taco Team Server</title></head><body style=\"background-color:#1F778D\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\"><span style=\"font-size:28px;\">You did it! Have a &#127790;</span></span></p></body></html>' | sudo tee /usr/share/nginx/html/index.html
  EOF
  tags = local.common_tags
}
