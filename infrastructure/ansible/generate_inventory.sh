#!/bin/bash

# Get Terraform output by accessing ../terraform/
BASTION_IP=$(cd ../terraform && terraform output -raw bastion_ip)
MASTER_IP=$(cd ../terraform && terraform output -raw master_private_ip)
WORKER_IP=$(cd ../terraform && terraform output -raw worker_private_ip)

# Create inventory directory if it doesn't exist
mkdir -p inventory

# Write inventory file
cat <<EOF > inventory/hosts.ini
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
