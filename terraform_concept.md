# Terraform core concepts
## 1. Providers
- A provider is a plugin that allows Terraform to interact with various cloud platforms and services. It defines the resources and data sources that can be managed by Terraform. Examples of providers include AWS, Azure, Google Cloud, and many others.
  Example:
  ```hcl
  provider "aws" {
            region = "ap-southeast-1" 
    }
  ```
## 2. Resources
- Resources are the fundamental building blocks of Terraform configurations. They represent the infrastructure components that you want to create, manage, or update. Each resource has a type (e.g., `aws_instance`, `google_compute_instance`) and a set of arguments that define its properties.
  Example:
  ```hcl
  resource "aws_instance" "example" {
            ami           = "ami-0c55b159cbfafe1f0"
            instance_type = "t2.micro"
    }
  ```
## 3. Data Sources
- Data sources allow you to fetch and use information from existing infrastructure or external sources. They are    read-only and can be used to reference existing resources or retrieve data that can be used in your Terraform configurations.
  Example:
  ```hcl

     Data"aws_ami" "example" {
                most_recent = true
                filter {
                    name   = "name"
                    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
                }
        }
  ```
## 4. Variables
- Variables are used to parameterize your Terraform configurations, allowing you to reuse and customize them. They can be defined with a type, default value, and description. Variables can be set through command-line arguments, environment variables, or variable files.
  Example:
  ```hcl
    ## initialize variable
    variable "instance_type" {
            type    = string
            default = "t2.micro"
            description = "The type of instance to create"
    }
    ## use variable into resource
    resource "aws_instance" "example" {
            ami           = "ami-0c55b159cbfafe1f0"
            instance_type = var.instance_type
    }
    ### config output variable
    output "instance_type" {
            value       = var.instance_type
            description = "The type of instance created"
    }
    
  ```
## 5. Outputs
- Outputs are used to display information about the resources created by Terraform. They can be defined with a value and an optional description. Outputs can be used to provide information to users or to pass data between different Terraform configurations.
  Example:
  ```hcl
    output "instance_id" {
            value       = aws_instance.example.id
            description = "The ID of the created instance"
    }
  ```
## 6. State
- Terraform maintains a state file that keeps track of the resources it manages. The state file is used to determine the current state of the infrastructure and to plan changes when you run `terraform apply`. It is important to manage the state file carefully, especially when working in teams, to avoid conflicts and ensure consistency.
  Example:
  ```hcl
    terraform {
            backend "s3" {
                bucket = "my-terraform-state"
                key    = "state.tfstate"
                region = "us-west-2"
            }
    }
  ```
## 7. Commands  of terraform
- `terraform init`: Initializes a Terraform configuration, setting up the backend and installing necessary providers.
- `terraform plan`: Creates an execution plan, showing what actions Terraform will take to achieve the desired state defined in the configuration.
  - How to read the output of `terraform plan`:
    - Lines starting with `+` indicate resources that will be created.
    - Lines starting with `-` indicate resources that will be destroyed.
    - Lines starting with `~` indicate resources that will be updated in place.
- `terraform apply`: Applies the changes required to reach the desired state of the configuration.
- `terraform destroy`: Destroys the infrastructure managed by Terraform, removing all resources defined in the configuration.
## 8 .gitignore (Ignore files in version control)
- When working with Terraform, it is important to ignore certain files and directories in your version control
- system (e.g., Git) to avoid committing sensitive information or unnecessary files. A common `.gitignore` file for a Terraform project might include:
  ```
  # Ignore Terraform state files
  *.tfstate
  *.tfstate.backup

  # Ignore .terraform directory (contains provider plugins and modules)
  .terraform/

  # Ignore crash logs
  crash.log

  # Ignore override files (if any)
  override.tf
  override.tf.json
  *_override.tf
  *_override.tf.json

  # Ignore local configuration files (if any)
  .terraformrc
  terraform.rc
  ```