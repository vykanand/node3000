#!/bin/bash

# Function to install required utilities
install_utilities() {
  echo "Installing required utilities..."
  sudo apt update
  sudo apt install -y curl unzip
}

# Function to install Terraform
install_terraform() {
  echo "Installing Terraform..."
  TERRAFORM_VERSION="1.5.4"  # Specify the version to install
  TERRAFORM_ZIP="terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
  
  # Download Terraform
  curl -LO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/${TERRAFORM_ZIP}"
  
  # Unzip and install Terraform
  unzip ${TERRAFORM_ZIP}
  sudo mv terraform /usr/local/bin/
  rm ${TERRAFORM_ZIP}
  
  # Verify installation
  terraform version
}

# Function to install Ansible
install_ansible() {
  echo "Installing Ansible..."
  
  # Install Ansible
  sudo apt update
  sudo apt install -y software-properties-common
  sudo add-apt-repository --yes --update ppa:ansible/ansible
  sudo apt install -y ansible

  # Verify installation
  ansible --version
}

# Function to install Python and pip (needed for some Ansible scripts)
install_python_pip() {
  echo "Installing Python and pip..."
  sudo apt install -y python3 python3-pip
}

# Function to install additional Python packages
install_python_packages() {
  echo "Installing additional Python packages..."
  pip3 install requests
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

  # Ensure oci_inventory.py is executable
  chmod +x oci_inventory.py

  # Generate Ansible inventory
  ./oci_inventory.py > inventory.json

  # Run Ansible playbook
  ansible-playbook -i inventory.json kubernetes_setup.yml
}

# Main script execution
echo "Starting setup process..."

# Install required utilities
install_utilities

# Install Terraform and Ansible
install_terraform
install_ansible

# Install Python and pip
install_python_pip

# Install additional Python packages
install_python_packages

# Run Terraform and Ansible commands
run_terraform
run_ansible

echo "Setup and configuration complete."
