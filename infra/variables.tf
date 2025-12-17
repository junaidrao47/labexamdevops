# ============================================
# Terraform Variables
# Input variables for infrastructure
# ============================================

# ============================================
# General Variables
# ============================================
variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "node-redis-mongo"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "owner" {
  description = "Owner of the infrastructure"
  type        = string
  default     = "junaidrao47"
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

# ============================================
# VPC Variables
# ============================================
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use single NAT Gateway (cost saving for dev)"
  type        = bool
  default     = true
}

# ============================================
# Network Access Controls (Best Practice)
# ============================================
variable "allowed_k8s_api_cidrs" {
  description = "CIDRs allowed to access the EKS API endpoint (443). Replace 0.0.0.0/0 with your public IP/32 in real use."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_ssh_cidrs" {
  description = "CIDRs allowed to SSH to nodes/EC2 instances (22). Replace 0.0.0.0/0 with your public IP/32 in real use."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_nodeport_cidrs" {
  description = "CIDRs allowed to access NodePort services (30000-32767)."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# ============================================
# EKS Variables
# ============================================
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "node-redis-mongo-cluster"
}

variable "cluster_version" {
  description = "Kubernetes version for EKS"
  type        = string
  default     = "1.28"
}

variable "node_instance_types" {
  description = "EC2 instance types for EKS nodes"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 4
}

# ============================================
# EC2 Variables (Fallback option)
# ============================================
variable "use_ec2_fallback" {
  description = "Use EC2 instances instead of EKS (cost saving)"
  type        = bool
  default     = false
}

variable "ec2_instance_type" {
  description = "EC2 instance type for fallback"
  type        = string
  default     = "t3.medium"
}

variable "ec2_key_name" {
  description = "SSH key pair name for EC2 instances"
  type        = string
  default     = ""
}

# ============================================
# RDS Variables
# ============================================
variable "create_rds" {
  description = "Create RDS PostgreSQL instance"
  type        = bool
  default     = true
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "nodeapp"
}

variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "db_password" {
  description = "Database master password"
  type        = string
  default     = ""
  sensitive   = true
}

variable "db_allocated_storage" {
  description = "Allocated storage for RDS (GB)"
  type        = number
  default     = 20
}

# ============================================
# S3 Variables
# ============================================
variable "create_s3_bucket" {
  description = "Create S3 bucket for backups/assets"
  type        = bool
  default     = true
}

variable "s3_bucket_name" {
  description = "S3 bucket name (must be globally unique)"
  type        = string
  default     = ""
}
