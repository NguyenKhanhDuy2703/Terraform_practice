# Terraform AWS Project Structure

A professional Terraform AWS project is usually organized into reusable modules and environment-specific deployments.

## 1. Recommended Project Layout

```text
terraform-aws-project/
|
|-- modules/                        # Reusable building blocks
|   |-- vpc/                        # Networking (VPC, subnets, routes, IGW, NAT)
|   |   |-- main.tf
|   |   |-- variables.tf
|   |   `-- outputs.tf
|   |
|   |-- ec2_instance/               # Compute (EC2, security groups, IAM profile)
|   |   |-- main.tf
|   |   |-- variables.tf
|   |   `-- outputs.tf
|   |
|   `-- s3_bucket/                  # Storage (S3 buckets, policies, encryption)
|       |-- main.tf
|       |-- variables.tf
|       `-- outputs.tf
|
|-- environments/                   # Real deployments per environment
|   |-- dev/
|   |   |-- main.tf                 # Calls ../../modules/* with dev values
|   |   |-- variables.tf            # Input variable definitions
|   |   |-- terraform.tfvars        # Dev values (optional)
|   |   |-- outputs.tf
|   |   `-- backend.tf              # Remote state config for dev
|   |
|   `-- prod/
|       |-- main.tf
|       |-- variables.tf
|       |-- terraform.tfvars        # Prod values (optional)
|       |-- outputs.tf
|       `-- backend.tf              # Remote state config for prod
|
|-- .gitignore                      # Ignore sensitive and local files
|-- Makefile                        # Helper commands (init, plan, apply, destroy)
`-- README.md                       # Project usage and architecture notes
```

## 2. What Each Part Does

- `modules/`: write Terraform once, reuse many times.
- `environments/`: compose modules with different values for each stage (`dev`, `prod`).
- `backend.tf`: keeps Terraform state remote (recommended: S3 + DynamoDB lock for AWS).
- `variables.tf`: defines expected inputs and types.
- `outputs.tf`: exports values for other modules or environments.

## 3. Typical Workflow

```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

For production, run the same flow in `environments/prod` after review and approvals.

## 4. Best Practices

- Keep module logic generic; keep environment differences in `*.tfvars`.
- Never commit secrets, state files, or credentials.
- Use consistent naming and tagging across all resources.
- Use remote state and state locking in team environments.
- Validate with `terraform fmt`, `terraform validate`, and `terraform plan` before apply.

## 5. Mapping to This Repository

In this repository, your current module structure is:

- `modules/network` for VPC, subnet, route table, and IGW.
- `modules/compute` for AMI lookup and EC2 creation.
- `environments/dev` and `environments/prod` for environment-level deployments.

This follows the same professional pattern described above.
