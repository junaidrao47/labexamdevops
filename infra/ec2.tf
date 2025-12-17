# ============================================
# EC2 Fallback Option (If not using EKS)
# Provisions a single EC2 instance in the public subnet.
# ============================================

locals {
  create_ec2 = var.use_ec2_fallback ? 1 : 0
}

# Latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security group for the EC2 instance (SSH restricted; HTTP/HTTPS open by default for lab)
resource "aws_security_group" "ec2_instance" {
  count       = local.create_ec2
  name        = "${var.project_name}-ec2-sg-${var.environment}"
  description = "Security group for EC2 fallback instance"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidrs
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "App Port"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ec2-sg-${var.environment}"
  }
}

# EC2 instance (fallback)
resource "aws_instance" "app" {
  count         = local.create_ec2
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.ec2_instance_type

  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.ec2_instance[0].id]

  key_name = var.ec2_key_name != "" ? var.ec2_key_name : null

  # Minimal user-data: install Docker so Ansible can deploy later (Step 4)
  user_data = <<-EOF
              #!/bin/bash
              set -euo pipefail
              dnf -y update
              dnf -y install docker
              systemctl enable docker
              systemctl start docker
              usermod -aG docker ec2-user
              EOF

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit  = 2
  }

  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name = "${var.project_name}-ec2-${var.environment}"
  }
}