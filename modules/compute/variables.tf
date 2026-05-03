
variable "aws_instance_type" {
  type = string
  default = "t2.micro"
}
variable "aws_ami_name" {
  type = string
  default = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
}
variable "instance_name" {
  type = string
  description = "SERVER EC2"
}
variable "enviroment" {
  type = string
  description = "dev"
}
variable "private_subnet_id" {
  type = string
  description = "Get from private subnet"
}
