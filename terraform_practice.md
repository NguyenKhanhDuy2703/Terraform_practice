# Terraform Practice — Professional Guide

**Purpose**

- A concise, professional walkthrough for creating a VPC, public and private subnets, an Internet Gateway (IGW) and route tables, and launching an EC2 instance (Ubuntu). This guide follows the layout used in this repository: modular Terraform with `modules/` and `environments/`.

**Scope**

- Environment: `environments/dev`
- Modules referenced: `modules/network`, `modules/compute`

**Prerequisites**

- Terraform installed and in PATH
- AWS CLI configured (`aws configure`) or credentials available via environment/IAM role
- Working directory: project root (this repo)

**Quick commands**

```bash
cd environments/dev
make init
make plan
make apply   # review plan before apply if not using -auto-approve
```

1. **Project layout (Large step)**

- Keep a modular layout: `modules/network`, `modules/compute`, `environments/dev`, `environments/prod`.
- Store environment-specific inputs in `environments/<env>/variables.tf` or `terraform.tfvars`.
- Keep reusable defaults in `modules/*/variables.tf`.

2. **Provider configuration (Small step)**

- Add the AWS provider in `environments/dev/main.tf`:

```hcl
provider "aws" {
  region = var.region
}
```

- Supply credentials using `aws configure`, environment variables (`AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY`), or an IAM role — do not hardcode credentials.

3. **Networking: VPC, Subnets (Large step)**

- Goal: create one VPC, one public subnet, and one private subnet.
- Example resources (in `modules/network/main.tf`):
  - `aws_vpc.vpc` with `cidr_block = var.vpc_cidr`
  - `aws_subnet.public_subnet` with `cidr_block = var.public_subnet_cidr`
  - `aws_subnet.private_subnet` with `cidr_block = var.private_subnet_cidr`

Example note: ensure subnet CIDRs are contained within the VPC CIDR. Example:

- VPC: `10.0.0.0/16`
- Public subnet: `10.0.1.0/24`
- Private subnet: `10.0.2.0/24`

4. **Internet Gateway and routing (Large step)**

- Create an IGW and attach to the VPC:

```hcl
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = { Name = "igw" }
}
```

- Create a public route table with a default route via IGW, then associate it with the public subnet:

```hcl
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public.id
}
```

5. **EC2 instance (Large step)**

- Use a data source to locate the latest Ubuntu AMI:

```hcl
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter { name = "name"; values = [var.aws_ami_name] }
}
```

- Create an instance in the private subnet (example in `modules/compute/main.tf`):

```hcl
resource "aws_instance" "free_tier" {
  ami                        = data.aws_ami.ubuntu.id
  instance_type              = var.aws_instance_type
  subnet_id                  = var.private_subnet_id
  associate_public_ip_address = false
  tags = { Name = var.instance_name }
}
```

- For secure access to private instances use a bastion host in the public subnet or AWS Systems Manager Session Manager.

6. **Outputs and module wiring (Small step)**

- Export required module outputs from `modules/network/outputs.tf`:

```hcl
output "private_subnet_id" { value = aws_subnet.private_subnet.id }
```

- Consume outputs in `environments/dev/main.tf`:

```hcl
module "dev_wed_server" {
  source           = "../../modules/compute"
  private_subnet_id = module.my_network.private_subnet_id
  # additional inputs
}
```

7. **Run and verify (Small step)**

- Commands:

```bash
cd environments/dev
make init
make plan
make apply
```

- Verify via Terraform state:

```bash
terraform state list
terraform state show module.my_network.aws_subnet.private_subnet
```

8. **Verify on AWS (Small step)**

- Console checks: EC2 → Instances; VPC → Your VPCs, Subnets, Route Tables, Internet Gateways.
- CLI checks:

```bash
aws ec2 describe-instances --filters "Name=tag:Name,Values=dev-wed-server"
aws ec2 describe-subnets --filters "Name=vpc-id,Values=<vpc-id>"
aws ec2 describe-route-tables --filters "Name=vpc-id,Values=<vpc-id>"
```

9. **Troubleshooting (Small step)**

- `InvalidSubnet.Range`: subnet CIDR must be inside the VPC CIDR and not overlap existing subnets.
- `Inappropriate value for attribute "route"`: use nested `route { ... }` blocks not `route = { ... }`.
- `This object does not have an attribute named ...`: export outputs from modules and reference `module.<name>.<output>`.

10. **Security & best practices (Small step)**

- Never commit `terraform.tfvars`, credentials or private keys—add them to `.gitignore`.
- Use IAM roles/instance profiles in production.
- Prefer AWS Session Manager over SSH for private instances.

Appendix: Example `modules/network/variables.tf` (recommended)

```hcl
variable "vpc_cidr" { type = string; default = "10.0.0.0/16" }
variable "public_subnet_cidr" { type = string; default = "10.0.1.0/24" }
variable "private_subnet_cidr" { type = string; default = "10.0.2.0/24" }
variable "availability_zone" { type = string }
```

Appendix: Example `modules/compute/variables.tf` (recommended)

```hcl
variable "aws_ami_name" { type = string; default = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*" }
variable "aws_instance_type" { type = string; default = "t2.micro" }
variable "instance_name" { type = string }
variable "private_subnet_id" { type = string }
```

Next steps

- I can: (a) add concrete `variables.tf`/`outputs.tf` files to this repo, (b) produce a minimal runnable example and README, or (c) translate this guide into Vietnamese.

---
