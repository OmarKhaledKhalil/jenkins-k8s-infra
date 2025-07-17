#!/bin/bash

# Get Terraform outputs
BASTION_IP=$(terraform output -raw bastion_ip)
MASTER_IP=$(terraform output -raw master_private_ip)
WORKER_IP=$(terraform output -raw worker_private_ip)

# Generate the hosts.ini
cat <<EOF > infrastructure/ansible/inventory/hosts.ini
[bastion]
$BASTION_IP

[master]
$MASTER_IP

[worker]
$WORKER_IP

[all:vars]
ansible_user=ec2-user
ansible_ssh_private_key_file=~/.ssh/jenkins-key.pem
EOF
