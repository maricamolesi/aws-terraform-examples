#!/bin/bash

# Initialize Terraform
echo "Initializing Terraform..."
terraform init

# Apply changes to the environment
echo "Applying changes to the environment..."
terraform apply -auto-approve