variable "region" {
  type = string
  default = "ap-southeast-1"
}
variable "aws_ami_name" {
  type = string
  default = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
}
variable "instance_name" {
  type = string
  default = "dev-wed-server"
}
variable "aws_instance_type" {
  type = string
  default = "t2.micro"
}
variable "enviroment" {
  type = string
  default = "dev"
}

variable "public_subnet_cidr" {
    type = string
    default = "10.0.1.0/24"
}
variable "private_subnet_cidr" {
    type = string
    default = "10.0.2.0/24"
}
variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}
variable "availability_zone" {
    type = string
    default = "us-east-1a"
}
