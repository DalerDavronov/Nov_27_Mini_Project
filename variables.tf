variable "security_groups" {
  description = "A map of security groups with their rules"
  type = map(object({
    description = string
    ingress_rules = optional(list(object({
      description = optional(string)
      priority    = optional(number)
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    })))
    egress_rules = list(object({
      description = optional(string)
      priority    = optional(number)
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  }))
}

variable "subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
}
variable "prefix" {
  type    = string
  default = "mini_project"
}
# variable "subnets" {
#   type = map(object({
#     name              = string
#     cidr_block        = string
#     availability_zone = string
#   }))

#   default = {
#     app = {
#       name              = "APP"
#       cidr_block        = "10.0.5.0/24"
#       availability_zone = "us-east-1a"
#     },
#     dev = {
#       name              = "DEV"
#       cidr_block        = "10.0.6.0/24"
#       availability_zone = "us-east-1b"
#     },
#     web = {
#       name              = "WEB"
#       cidr_block        = "10.0.7.0/24"
#       availability_zone = "us-east-1c"
#     },
#   }
# }
# variable "prefix" {
#   type    = string
#   default = "mini_project"
# }
variable "instances" {
  type = map(object({
    subnet_name = string,
    # cidr_block = string
    # availability_zone = string
  }))
  default = {
    App = {
      subnet_name = "pub_sub_1"
    }
    Dev = {
      subnet_name = "pub_sub_2"
    }
    Web = {
      subnet_name = "pub_sub_3"
    }
  }
}