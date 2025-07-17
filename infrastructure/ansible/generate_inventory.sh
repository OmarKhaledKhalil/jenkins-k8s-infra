#!/bin/bash

TF_DIR="$(cd "$(dirname "$0")/../terraform" && pwd)"

# Get Terraform outputs
BASTION_IP=$(cd "$TF_DIR" && terraform output -raw bastion_ip)
MASTER_IP=$(cd "$TF_DIR" && terraform output -raw master_private_ip)
WORKER_IP=$(cd "$TF_DIR" && terraform output -raw worker_private_ip)

INVENTORY_DIR="$(cd "$(dirname "$0")" && pwd)/inventory"
mkdir -p "$INVENTORY_DIR"

# Path to SSH key (passed from Jenkins)
SSH_KEY_PATH=$1

# Write Ansible inventory
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
