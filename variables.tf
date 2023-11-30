variable "subnets" {
  default = {
    public_us_east_1a = {
      cidr_block             = "10.0.1.0/24"
      availability_zone       = "us-east-1a"
      map_public_ip_on_launch = true
    }
    public_us_east_1b = {
      cidr_block             = "10.0.2.0/24"
      availability_zone       = "us-east-1b"
      map_public_ip_on_launch = true
    }
   public_us_east_1c = {
      cidr_block             = "10.0.3.0/24"
      availability_zone       = "us-east-1c"
      map_public_ip_on_launch = true
    } 
    private_us_east_1a = {
      cidr_block             = "10.0.4.0/24"
      availability_zone       = "us-east-1a"
      map_public_ip_on_launch = false
    }
    private_us_east_1b = {
      cidr_block             = "10.0.5.0/24"
      availability_zone       = "us-east-1b"
      map_public_ip_on_launch = false
    }
    private_us_east_1c = {
      cidr_block             = "10.0.6.0/24"
      availability_zone       = "us-east-1c"
      map_public_ip_on_launch = false
    }
  }
}

variable "ami" {
  type = map

  default = {
    "us-east-1" = "ami-0230bd60aa48260c6"
  }
}

variable "instance_count" {
  default = "3"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "aws_region" {
  default = "us-east-1"
}