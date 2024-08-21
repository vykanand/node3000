#!/bin/bash

# Function to install Terraform
install_terraform() {
  echo "Installing Terraform..."
  TERRAFORM_VERSION="1.5.4"  # Specify the version to install
  TERRAFORM_ZIP="terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
  
  # Download and install Terraform
  curl -LO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/${TERRAFORM_ZIP}"
  unzip ${TERRAFORM_ZIP}
  sudo mv terraform /usr/local/bin/
  rm ${TERRAFORM_ZIP}
  
  # Verify installation
  terraform version
}

# Function to install Ansible
install_ansible() {
  echo "Installing Ansible..."
  
  # Update package index
  sudo apt update
  
  # Install Ansible
  sudo apt install -y ansible

  # Verify installation
  ansible --version
}

# Function to run Terraform commands
run_terraform() {
  echo "Running Terraform commands..."

  # Initialize Terraform
  terraform init

  # Apply Terraform configuration
  terraform apply -auto-approve

  # Capture Terraform outputs
  terraform output -json > terraform_outputs.json
}

# Function to run Ansible commands
run_ansible() {
  echo "Running Ansible commands..."

  # Generate Ansible inventory
  ./oci_inventory.py > inventory.json

  # Run Ansible playbook
  ansible-playbook -i inventory.json kubernetes_setup.yml
}

# Main script execution
echo "Starting setup process..."

# Install Terraform and Ansible
install_terraform
install_ansible

# Run Terraform and Ansible commands
run_terraform
run_ansible

echo "Setup and configuration complete."
