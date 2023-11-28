terraform {
  cloud {
    organization = "Ziyotek_Terraform_Class_Summer_Cloud"

    workspaces {
      name = "Nov_17_Handson_Lab"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}


resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block             = "10.0.1.0/24"
  availability_zone       = "us-east-1a" 
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-igw"
  }
}

resource "aws_vpc_attachment" "main" {
  vpc_id          = aws_vpc.main.id
  internet_gateway_id = aws_internet_gateway.main.id
}

resource "aws_security_group" "allow_http" {
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-http-sg"
  }
}


resource "aws_instance" "web" {
  ami             = "ami-0230bd60aa48260c6"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public.id
  security_group  = [aws_security_group.allow_http.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello World from $(hostname -f)" > /var/www/html/index.html
              systemctl enable httpd
              systemctl start httpd
              EOF

  tags = {
    Name = "web-instance"
  }
}


output "public_ip" {
  value = aws_instance.web.public_ip
}