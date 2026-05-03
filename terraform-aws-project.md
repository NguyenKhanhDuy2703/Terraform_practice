# Structure of a Terraform AWS Project
A Terraform AWS project typically consists of several key components that work together to define and manage your infrastructure on AWS. Below are the main components of a Terraform AWS project:
terraform-aws-project/
│
├── modules/                   # Chứa các module dùng chung (Tái sử dụng code)
│   ├── vpc/                   # Cấu hình Mạng
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── ec2_instance/          # Cấu hình Máy chủ EC2
│   └── s3_bucket/             # Cấu hình Lưu trữ S3
│
├── environments/              # Nơi gọi các modules để triển khai thực tế
│   ├── dev/                   # Môi trường Development
│   │   ├── main.tf            # Gọi tới ../../modules/vpc, ../../modules/ec2...
│   │   ├── variables.tf       # Biến riêng cho Dev (vd: instance_type = "t2.micro")
│   │   ├── outputs.tf
│   │   └── backend.tf         # Cấu hình lưu State file lên S3 cho Dev
│   │
│   └── prod/                  # Môi trường Production
│       ├── main.tf
│       ├── variables.tf       # Biến riêng cho Prod (vd: instance_type = "t3.large")
│       └── backend.tf         # Cấu hình lưu State file lên S3 cho Prod
