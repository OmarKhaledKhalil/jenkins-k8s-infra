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

# Define private key path used inside Jenkins container
KEY_PATH=~/.ssh/jenkins-key.pem

# Write inventory file with jump host config
cat <<EOF > "${INVENTORY_DIR}/hosts.ini"
[master]
${MASTER_IP} ansible_user=ec2-user ansible_ssh_private_key_file=$KEY_PATH ansible_ssh_common_args='-o ProxyCommand="ssh -i $KEY_PATH -W %h:%p ec2-user@$BASTION_IP"'

[worker]
${WORKER_IP} ansible_user=ec2-user ansible_ssh_private_key_file=$KEY_PATH ansible_ssh_common_args='-o ProxyCommand="ssh -i $KEY_PATH -W %h:%p ec2-user@$BASTION_IP"'

[bastion]
${BASTION_IP} ansible_user=ec2-user ansible_ssh_private_key_file=$KEY_PATH

[all:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOF
