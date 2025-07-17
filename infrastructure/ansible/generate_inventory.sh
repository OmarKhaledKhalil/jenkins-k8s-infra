#!/bin/bash

# Set the Terraform directory relative to this script
TF_DIR="$(cd "$(dirname "$0")/../terraform" && pwd)"

# Get Terraform outputs
BASTION_IP=$(cd "$TF_DIR" && terraform output -raw bastion_ip)
MASTER_IP=$(cd "$TF_DIR" && terraform output -raw master_private_ip)
WORKER_IP=$(cd "$TF_DIR" && terraform output -raw worker_private_ip)

# Define inventory directory relative to this script
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INVENTORY_DIR="${SCRIPT_DIR}/inventory"

# Create inventory directory if not exists
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

