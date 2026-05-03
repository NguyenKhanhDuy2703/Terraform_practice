init-dev:
	cd environments/dev && terraform init
	echo "Terraform initialized successfully for dev environment."
plan-dev:
	cd environments/dev && terraform plan 
	echo "Terraform plan generated successfully for dev environment."
apply-dev:
	cd environments/dev && terraform apply
	echo "Terraform applied successfully for dev environment."
destroy-dev:
	cd environments/dev && terraform destroy
	echo "Terraform destroyed successfully for dev environment."
show-dev:
	cd environments/dev && terraform show
	echo "Terraform state displayed successfully for dev environment."
validate-dev:
	cd environments/dev && terraform validate
	echo "Terraform configuration validated successfully for dev environment."
output-dev:
	cd environments/dev && terraform output
	echo "Terraform outputs displayed successfully for dev environment."