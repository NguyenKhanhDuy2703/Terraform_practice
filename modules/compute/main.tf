data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = [var.aws_ami_name]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
resource "aws_instance" "free_tier" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "${var.aws_instance_type}"
  subnet_id =  var.private_subnet_id
  associate_public_ip_address = false
  tags = {
    Name = "${var.instance_name}"
    Environment = "${var.enviroment}"
    ManagedBy = "Terraform"
  }

}
