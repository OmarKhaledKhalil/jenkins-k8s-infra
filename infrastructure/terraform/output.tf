output "bastion_ip" {
  value = aws_instance.bastion.public_ip
}

output "master_ip" {
  value = aws_instance.master.public_ip
}

output "worker_ip" {
  value = aws_instance.worker.public_ip
}

