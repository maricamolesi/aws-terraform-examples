#!/bin/bash

# Initialize Terraform
echo "Initializing Terraform..."
terraform init  # Initializes the Terraform directory, downloads necessary plugins, and prepares the environment.

# Apply changes to the environment
echo "Applying changes to the environment..."
terraform apply -auto-approve  # Applies the changes described in the Terraform code without requiring manual confirmation.
