#!/bin/bash

# Set the Terraform directory relative to this script
TF_DIR="$(cd "$(dirname "$0")/../terraform" && pwd)"

# Get Terraform outputs
BASTION_IP=$(cd "$TF_DIR" && terraform output -raw bastion_ip)
MASTER_IP=$(cd "$TF_DIR" && terraform output -raw master_private_ip)
WORKER_IP=$(cd "$TF_DIR" && terraform output -raw worker_private_ip)

echo "📥 Terraform Outputs:"
echo "Bastion IP: $BASTION_IP"
echo "Master IP:  $MASTER_IP"
echo "Worker IP:  $WORKER_IP"

# Define inventory directory relative to this script
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INVENTORY_DIR="${SCRIPT_DIR}/inventory"

# Create inventory directory if it doesn't exist
mkdir -p "$INVENTORY_DIR"

# Write inventory file
cat <<EOF > "${INVENTORY_DIR}/hosts.ini"
[bastion]
${BASTION_IP}

[master]
${MASTER_IP} ansible_ssh_common_args='-o ProxyCommand="ssh -i ~/.ssh/jenkins-key.pem -W %h:%p ec2-user@${BASTION_IP}" -o StrictHostKeyChecking=no'

[worker]
${WORKER_IP} ansible_ssh_common_args='-o ProxyCommand="ssh -i ~/.ssh/jenkins-key.pem -W %h:%p ec2-user@${BASTION_IP}" -o StrictHostKeyChecking=no'

[all:vars]
ansible_user=ec2-user
ansible_ssh_private_key_file=~/.ssh/jenkins-key.pem
EOF

echo "✅ Inventory file generated at ${INVENTORY_DIR}/hosts.ini"
