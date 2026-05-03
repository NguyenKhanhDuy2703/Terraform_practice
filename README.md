# Terraform Basic AWS Project

A modular Terraform project to provision core AWS infrastructure for learning and practice.

## Overview

This repository currently focuses on the `dev` environment and provisions:

- A custom VPC
- One public subnet
- One private subnet
- Internet Gateway (IGW)
- Public and private route tables + subnet associations
- One EC2 instance in the private subnet (no public IP)

The project uses reusable modules under `modules/` and environment entrypoints under `environments/`.

## Current Project Structure

```text
Terraform_basic/
|-- environments/
|   |-- dev/
|   |   |-- backend.tf
|   |   |-- main.tf
|   |   |-- variables.tf
|   |   |-- terraform.tfstate
|   |   `-- terraform.tfstate.backup
|   `-- prod/
|       |-- backend.tf
|       |-- main.tf
|       `-- variables.tf
|-- modules/
|   |-- network/
|   |   |-- main.tf
|   |   |-- variables.tf
|   |   `-- outputs.tf
|   `-- compute/
|       |-- main.tf
|       |-- variables.tf
|       `-- outputs.tf
|-- Makefile
|-- structure.md
|-- terraform_practice.md
|-- terraform-aws-project.md
`-- .gitignore
```

## Module Design

### `modules/network`

Creates network resources:

- `aws_vpc.vpc`
- `aws_subnet.public_subnet`
- `aws_subnet.private_subnet`
- `aws_internet_gateway.igw`
- `aws_route_table.associate_public_subnet`
- `aws_route_table.associate_private_subnet`
- `aws_route_table_association.public_subnet_association`
- `aws_route_table_association.private_subnet_association`

Output:

- `private_subnet_id`

### `modules/compute`

Creates compute resources:

- `data.aws_ami.ubuntu` (auto-select latest matching Ubuntu AMI)
- `aws_instance.free_tier` (launched in private subnet)

Outputs:

- `server_public_ip`
- `server_id`
- `server_public_dns`

## Environment Wiring

### `environments/dev/main.tf`

- Configures provider region
- Calls `module "my_network"`
- Calls `module "dev_wed_server"`
- Passes `module.my_network.private_subnet_id` into compute module

### `environments/prod/`

`prod` files currently exist as placeholders and are not implemented yet.

## Prerequisites

- Terraform installed
- AWS CLI installed
- AWS credentials configured (`aws configure`)
- GNU Make installed (optional but recommended)

## Quick Start

Run from repository root:

```bash
make init-dev
make validate-dev
make plan-dev
make apply-dev
```

Useful commands:

```bash
make show-dev
make output-dev
make destroy-dev
```

## Important Configuration Notes

1. Ensure `region` and `availability_zone` are aligned.

- Current `dev` defaults:
  - `region = "ap-southeast-1"`
  - `availability_zone = "us-east-1a"`
- These should be in the same region to avoid deployment errors.

Example fix for Singapore region:

```hcl
region = "ap-southeast-1"
availability_zone = "ap-southeast-1a"
```

2. Ensure subnet CIDRs are inside the VPC CIDR.

Recommended set (already used by default):

- `vpc_cidr = 10.0.0.0/16`
- `public_subnet_cidr = 10.0.1.0/24`
- `private_subnet_cidr = 10.0.2.0/24`

## Validation and Troubleshooting

Common checks:

```bash
cd environments/dev
terraform fmt -recursive
terraform validate
terraform plan
```

Common errors and fixes:

- `InvalidSubnet.Range`: subnet CIDR is outside VPC CIDR or overlaps another subnet.
- `Inappropriate value for attribute "route"`: use nested `route {}` block in route table.
- `Unsupported attribute module...`: ensure module outputs are declared and referenced correctly.

## Security Notes

Sensitive files are ignored in `.gitignore`, including:

- Terraform state files
- `.terraform/`
- `*.tfvars`
- AWS credentials files
- private keys (`*.pem`, `*.key`)

Do not commit secrets or state files to Git.

## Next Improvements

- Implement `environments/prod` with production-safe values
- Add remote backend in `backend.tf` (S3 + DynamoDB lock)
- Add security groups and stricter ingress/egress rules
- Add NAT Gateway if private instances need outbound internet access
- Add CI checks (`terraform fmt`, `validate`, `plan`) before merge
