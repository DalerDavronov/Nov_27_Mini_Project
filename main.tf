resource "aws_key_pair" "key" {
  key_name   = "${var.prefix}-key"
  public_key = file("~/.ssh/id_rsa.pub")
}
resource "aws_vpc" "main" {
  cidr_block = "172.16.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
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

  tags = {
    Name = "subnet-${each.key}"
  }
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

resource "aws_instance" "instances" {
  for_each      = var.instances
  ami           = "ami-0230bd60aa48260c6"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key.key_name

  subnet_id = aws_subnet.subnets[each.value.subnet_name].id
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  user_data              = <<-EOF
                              #!/bin/bash
                              sudo yum update -y
                              sudo yum install -y httpd
                              sudo systemctl start httpd.service
                              sudo systemctl enable httpd.service
                              sudo echo "<h1> Hello World from ${each.key}_Server </h1>" > /var/www/html/index.html                  
                              EOF
  tags = {
    Name = each.key
  }
}


resource "aws_eip" "eip" {
  for_each = var.instances
  instance = aws_instance.instances[each.key].id
  domain   = "vpc"
}


# import {
#   to = aws_key_pair.key
#   id = "ec2labhomework"
# }

# import {
#   to = aws_vpc.main
#   id = "vpc-08c90f81ac929b1d2"
# }

# import {
#   to = aws_internet_gateway.main
#   id = "igw-03a79cba15f1097bc"
# }

# import {
#   to = aws_route_table.public
#   id = "rtb-0cfee0dac09a6a3f1"
# }
# import {
#   to = aws_subnet.subnets["pub_sub_1"]
#   id = "subnet-0b656a32fff71cdb9"
# }

# import {
#   to = aws_subnet.subnets["pub_sub_2"]
#   id = "subnet-09035abb876d8e841"
# }

# import {
#   to = aws_subnet.subnets["pub_sub_3"]
#   id = "subnet-01c56d4ea67e4b6a8"
# }
# import {
#   to = aws_security_group.allow_http
#   id = "sg-0895884fb6e576325"
# }
# import {
#   to = aws_eip.eip["App"]
#   id = "eipalloc-02d2aa5bc1040a7c6"
# }

# import {
#   to =  aws_eip.eip["Dev"]
#   id = "eipalloc-0d2b86e65dfc6645a"
# }

# import {
#   to =  aws_eip.eip["Web"] 
#   id = "eipalloc-0a86b1d8671cb501f"
# }

# import {
#   to = aws_instance.instances["App"] 
#   id = "i-05b0ee7e8ab41b354"
# }

# import {
#   to = aws_instance.instances["Dev"]
#   id = "i-095103acdd114a56b"
# }

# import {
#   to = aws_instance.instances["Web"]
#   id = "i-05c900f1479148454"
# }

# import {
#   to = aws_route_table_association.public["pub_sub_1"]
#   id = "subnet-0b656a32fff71cdb9/rtb-0cfee0dac09a6a3f1"
# }

# import {
#   to = aws_route_table_association.public["pub_sub_2"] 
#   id = "subnet-09035abb876d8e841/rtb-0cfee0dac09a6a3f1"
# }

# import {
#   to = aws_route_table_association.public["pub_sub_3"]
#   id = "subnet-01c56d4ea67e4b6a8/rtb-0cfee0dac09a6a3f1"
# }
output "my_eip" {
  value = { for k, v in aws_eip.eip : k => v.public_ip }
}

