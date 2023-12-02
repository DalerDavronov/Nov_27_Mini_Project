variable "subnets" {
  default = {
    public_us_east_1a = {
      cidr_block             = "10.0.1.0/24"
      availability_zone       = "us-east-1a"
      
    }
    public_us_east_1b = {
      cidr_block             = "10.0.2.0/24"
      availability_zone       = "us-east-1b"
      
    }
   public_us_east_1c = {
      cidr_block             = "10.0.3.0/24"
      availability_zone       = "us-east-1c"
      
    } 
  }
}
variable "instances" {
  type = map(object({
    ami           = string
    instance_type = string
    key_name      = string
  }))
  default = {
    instance1 = {
      ami           = "ami-0230bd60aa48260c6",
      instance_type = "t2.micro",
      key_name      = "Web server",
    },
    instance2 = {
      ami           = "ami-0230bd60aa48260c6",
      instance_type = "t2.micro",
      key_name      = "App Server",
    },
    instance3 = {
      ami           = "ami-0230bd60aa48260c6",
      instance_type = "t2.micro",
      key_name      = "Dev Server",
    },
  }
}