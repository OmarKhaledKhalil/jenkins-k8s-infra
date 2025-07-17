#!/bin/bash

# === generate_inventory.sh ===
# Usage: ./generate_inventory.sh /path/to/private_key.pem
# This script generates the Ansible inventory file using Terraform outputs
# and configures master/worker SSH access via the bastion host.

# Validate SSH key input
SSH_KEY_PATH="$1"
if [ -z "$SSH_KEY_PATH" ]; then
  echo "❌ ERROR: SSH key path argument missing."
  echo "Usage: $0 /path/to/private_key.pem"
  exit 1
fi

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

# Write Ansible inventory file
cat <<EOF > "${INVENTORY_DIR}/hosts.ini"
[bastion]
${BASTION_IP}

[master]
${MASTER_IP} ansible_ssh_common_args='-o ProxyCommand="ssh -i ${SSH_KEY_PATH} -W %h:%p ec2-user@${BASTION_IP}" -o StrictHostKeyChecking=no'

[worker]
${WORKER_IP} ansible_ssh_common_args='-o ProxyCommand="ssh -i ${SSH_KEY_PATH} -W %h:%p ec2-user@${BASTION_IP}" -o StrictHostKeyChecking=no'

[all:vars]
ansible_user=ec2-user
ansible_ssh_private_key_file=${SSH_KEY_PATH}
EOF

echo "✅ Inventory file generated at ${INVENTORY_DIR}/hosts.ini"
