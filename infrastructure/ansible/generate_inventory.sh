#!/bin/bash

# Get Terraform outputs
BASTION_IP=$(cd ../terraform && terraform output -raw bastion_ip)
MASTER_IP=$(cd ../terraform && terraform output -raw master_private_ip)
WORKER_IP=$(cd ../terraform && terraform output -raw worker_private_ip)

# Go to the directory where this script resides
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# Define inventory path relative to script location
INVENTORY_DIR="${SCRIPT_DIR}/inventory"

# Create inventory directory if it doesn't exist
mkdir -p "$INVENTORY_DIR"

# Write inventory file
cat <<EOF > "${INVENTORY_DIR}/hosts.ini"
[bastion]
${BASTION_IP}

[master]
${MASTER_IP}

[worker]
${WORKER_IP}

[all:vars]
ansible_user=ec2-user
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOF
