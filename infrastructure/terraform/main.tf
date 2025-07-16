provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name     = "main-vpc --- Group B"
    Owner1   = "Omar Khaled"
    Owner2   = "Salma Walid"
    Owner3   = "Mariam Mohsen"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name     = "main-subnet --- Group B"
    Owner1   = "Omar Khaled"
    Owner2   = "Salma Walid"
    Owner3   = "Mariam Mohsen"
  }
}

resource "aws_security_group" "k8s_sg" {
  name        = "k8s-sg"
  description = "Allow SSH and Kubernetes ports"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name     = "k8s-security-group --- Group B"
    Owner1   = "Omar Khaled"
    Owner2   = "Salma Walid"
    Owner3   = "Mariam Mohsen"
  }
}

resource "aws_instance" "bastion" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 (us-east-1)
  instance_type = "t2.micro"
  key_name      = var.key_pair
  subnet_id     = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]

  tags = {
    Name     = "bastion-host --- Group B"
    Role     = "bastion"
    Owner1   = "Omar Khaled"
    Owner2   = "Salma Walid"
    Owner3   = "Mariam Mohsen"
  }
}

resource "aws_instance" "master" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.medium"
  key_name      = var.key_pair
  subnet_id     = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]

  tags = {
    Name     = "k8s-master --- Group B"
    Role     = "master"
    Owner1   = "Omar Khaled"
    Owner2   = "Salma Walid"
    Owner3   = "Mariam Mohsen"
  }
}

resource "aws_instance" "worker" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.medium"
  key_name      = var.key_pair
  subnet_id     = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]

  tags = {
    Name     = "k8s-worker --- Group B"
    Role     = "worker"
    Owner1   = "Omar Khaled"
    Owner2   = "Salma Walid"
    Owner3   = "Mariam Mohsen"
  }
}
