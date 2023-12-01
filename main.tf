resource "aws_key_pair" "Nov_27_Mini_Project" {
  key_name   = var.aws_key_pair
  public_key = file("~/.ssh/id_ed25519.pub")
}
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_instance" "instance1" {
  ami             = "ami-0230bd60aa48260c6"
  instance_type   = "t2.micro"
  key_name        = var.aws_key_pair
  vpc_security_group_ids = ["sg-03338ba344b0750c7"]
  security_groups = [aws_security_group.allow_http.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello World from $(hostname -f)" > /var/www/html/index.html
              systemctl enable httpd
              systemctl start httpd
              EOF

  tags = {
    Name = "App Server Instance"
  }
}

resource "aws_instance" "instance2" {
  ami             = "ami-0230bd60aa48260c6"
  instance_type   = "t2.micro"
  key_name        = var.aws_key_pair
  vpc_security_group_ids = ["sg-03338ba344b0750c7"]
  security_groups = [aws_security_group.allow_http.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello World from $(hostname -f)" > /var/www/html/index.html
              systemctl enable httpd
              systemctl start httpd
              EOF

  tags = {
    Name = "Dev Server Instance"
  }
}

resource "aws_instance" "instance3" {
  ami             = "ami-0230bd60aa48260c6"
  instance_type   = "t2.micro"
  key_name        = var.aws_key_pair
  vpc_security_group_ids = ["sg-03338ba344b0750c7"]
  security_groups = [aws_security_group.allow_http.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello World from $(hostname -f)" > /var/www/html/index.html
              systemctl enable httpd
              systemctl start httpd
              EOF

  tags = {
    Name = "Web Server Instance"
  }
}
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public" {
  for_each = var.subnets
  subnet_id      = aws_subnet.subnets[each.key].id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "subnets" {
  for_each = var.subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch

  tags = {
    Name = "subnet-${each.key}"
  }
}


# resource "aws_network_interface" "multi-ip" {
#   subnet_id   = aws_subnet.subnets.id
#   private_ips = ["10.0.0.10", "10.0.0.11", "10.0.0.12"]
# }

# resource "aws_eip" "one" {
#   domain                    = "vpc"
#   network_interface         = aws_network_interface.multi-ip.id
#   associate_with_private_ip = "10.0.0.10"
# }

# resource "aws_eip" "two" {
#   domain                    = "vpc"
#   network_interface         = aws_network_interface.multi-ip.id
#   associate_with_private_ip = "10.0.0.11"
# }
# resource "aws_eip" "three" {
#   domain                    = "vpc"
#   network_interface         = aws_network_interface.multi-ip.id
#   associate_with_private_ip = "10.0.0.12"
# }

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

output "App_Server_ip" {
  value = aws_instance.instance1.public_ip
}

output "Dev_Server_ip" {
  value = aws_instance.instance2.public_ip
}

output "Web_Server_ip" {
  value = aws_instance.instance3.public_ip
}