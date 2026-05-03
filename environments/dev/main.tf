provider "aws" {
  region = "${var.region}"
}

module "my_network" {
  source = "../../modules/network"
  public_subnet_cidr = "${var.public_subnet_cidr}"
  private_subnet_cidr = "${var.private_subnet_cidr}"
  vpc_cidr = "${var.vpc_cidr}"
  availability_zone = "${var.availability_zone}"

}

module "dev_wed_server" {
  source = "../../modules/compute"
  aws_ami_name = "${var.aws_ami_name}"
  instance_name = "${var.instance_name}"
  aws_instance_type = "${var.aws_instance_type}"
  enviroment = "${var.enviroment}"
  private_subnet_id = module.my_network.private_subnet_id
}