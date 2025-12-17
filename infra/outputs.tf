# ============================================
# Terraform Outputs
# Display important resource information
# ============================================

# ============================================
# VPC Outputs
# ============================================
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = aws_subnet.private[*].id
}

output "nat_gateway_ips" {
  description = "Elastic IPs of NAT Gateways"
  value       = aws_eip.nat[*].public_ip
}

# ============================================
# Security Group Outputs
# ============================================
output "eks_cluster_security_group_id" {
  description = "Security group ID for EKS cluster"
  value       = aws_security_group.eks_cluster.id
}

output "eks_nodes_security_group_id" {
  description = "Security group ID for EKS nodes"
  value       = aws_security_group.eks_nodes.id
}

output "application_security_group_id" {
  description = "Security group ID for application"
  value       = aws_security_group.application.id
}

output "database_security_group_id" {
  description = "Security group ID for database"
  value       = aws_security_group.database.id
}

output "cache_security_group_id" {
  description = "Security group ID for cache"
  value       = aws_security_group.cache.id
}

# ============================================
# EKS Outputs
# ============================================
output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = try(aws_eks_cluster.main[0].name, null)
}

output "eks_cluster_endpoint" {
  description = "Endpoint for EKS cluster"
  value       = try(aws_eks_cluster.main[0].endpoint, null)
}

output "eks_cluster_arn" {
  description = "ARN of the EKS cluster"
  value       = try(aws_eks_cluster.main[0].arn, null)
}

output "eks_cluster_version" {
  description = "Kubernetes version of EKS cluster"
  value       = try(aws_eks_cluster.main[0].version, null)
}

output "eks_cluster_certificate_authority" {
  description = "Certificate authority data for EKS cluster"
  value       = try(aws_eks_cluster.main[0].certificate_authority[0].data, null)
  sensitive   = true
}

output "eks_node_group_name" {
  description = "Name of the EKS node group"
  value       = try(aws_eks_node_group.main[0].node_group_name, null)
}

output "eks_node_group_arn" {
  description = "ARN of the EKS node group"
  value       = try(aws_eks_node_group.main[0].arn, null)
}

# ============================================
# RDS Outputs
# ============================================
output "rds_endpoint" {
  description = "Endpoint of RDS instance"
  value       = var.create_rds ? aws_db_instance.main[0].endpoint : null
}

output "rds_port" {
  description = "Port of RDS instance"
  value       = var.create_rds ? aws_db_instance.main[0].port : null
}

output "rds_database_name" {
  description = "Name of the database"
  value       = var.create_rds ? aws_db_instance.main[0].db_name : null
}

output "rds_username" {
  description = "Master username of RDS instance"
  value       = var.create_rds ? aws_db_instance.main[0].username : null
  sensitive   = true
}

output "rds_credentials_secret_arn" {
  description = "ARN of Secrets Manager secret containing DB credentials"
  value       = var.create_rds ? aws_secretsmanager_secret.db_credentials[0].arn : null
}

# ============================================
# S3 Outputs
# ============================================
output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = var.create_s3_bucket ? aws_s3_bucket.main[0].id : null
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = var.create_s3_bucket ? aws_s3_bucket.main[0].arn : null
}

output "s3_bucket_domain_name" {
  description = "Domain name of the S3 bucket"
  value       = var.create_s3_bucket ? aws_s3_bucket.main[0].bucket_domain_name : null
}

# ============================================
# Kubectl Config Command
# ============================================
output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = var.use_ec2_fallback ? null : "aws eks update-kubeconfig --region ${var.aws_region} --name ${aws_eks_cluster.main[0].name}"
}

# ============================================
# Summary
# ============================================
output "deployment_summary" {
  description = "Summary of deployed resources"
  value = {
    project     = var.project_name
    environment = var.environment
    region      = var.aws_region
    vpc_id      = aws_vpc.main.id
    eks_cluster = try(aws_eks_cluster.main[0].name, null)
    rds_enabled = var.create_rds
    s3_enabled  = var.create_s3_bucket
    ec2_fallback_enabled = var.use_ec2_fallback
  }
}

# ============================================
# EC2 Fallback Outputs
# ============================================
output "ec2_public_ip" {
  description = "Public IP of the fallback EC2 instance (if enabled)"
  value       = try(aws_instance.app[0].public_ip, null)
}

output "ec2_public_dns" {
  description = "Public DNS of the fallback EC2 instance (if enabled)"
  value       = try(aws_instance.app[0].public_dns, null)
}
