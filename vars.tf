variable "aws_region" {
  default = "eu-central-1"
  description = "AWS region"
}

variable "aws_profile" {
  default = "default"                  #use default if have only one
  description = "AWS region"
}


variable "vpc_name" {
  default = "todo"
  description = "Some VPCs names" #single vpc at this stage
}

variable "vpc_cidr" {
  default = "172.28.0.0/16"
  description = "172.28.0.0/16" #single vpc at this stage
}

variable "whitelisted_ip" {
  default = "0.0.0.0/0"
  description = "whitelisted ip"
}
