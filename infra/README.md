# Terraform Infrastructure

This directory contains Terraform configurations for provisioning AWS infrastructure for the Node-Redis-Mongo application.

## 📁 File Structure

```
infra/
├── main.tf             # Provider configuration and data sources
├── variables.tf        # Input variable definitions
├── vpc.tf              # VPC, Subnets, NAT Gateway, Route Tables
├── security-groups.tf  # Security groups for all resources
├── eks.tf              # EKS cluster and node group
├── ec2.tf              # EC2 fallback option (if not using EKS)
├── rds.tf              # RDS PostgreSQL database
├── s3.tf               # S3 bucket for storage
├── outputs.tf          # Output values
├── terraform.tfvars.example # Example variables (safe to commit)
├── terraform.tfvars    # Your local values (do NOT commit)
└── README.md           # This file
```

## 🏗️ Resources Created

| Resource | Description |
|----------|-------------|
| **VPC** | Virtual Private Cloud with DNS support |
| **Subnets** | 2 public + 2 private subnets across AZs |
| **Internet Gateway** | For public internet access |
| **NAT Gateway** | For private subnet outbound access |
| **Security Groups** | For EKS, App, Database, Cache |
| **EKS Cluster** | Managed Kubernetes cluster |
| **EKS Node Group** | Worker nodes for the cluster |
| **RDS PostgreSQL** | Managed database instance |
| **S3 Bucket** | Object storage with encryption |

## 🚀 Quick Start

### Prerequisites

1. **AWS CLI** installed and configured
2. **Terraform** >= 1.0.0 installed
3. **AWS credentials** with appropriate permissions

### Deploy Infrastructure

```bash
# Navigate to infra directory
cd infra

# Initialize Terraform
terraform init

# Review the execution plan
terraform plan

# Apply the configuration
terraform apply

# Get outputs
terraform output
```

### Configure kubectl

```bash
# Update kubeconfig for EKS
aws eks update-kubeconfig --region us-east-1 --name node-redis-mongo-cluster

# Verify connection
kubectl get nodes
```

### Destroy Infrastructure

```bash
# Destroy all resources (use with caution!)
terraform destroy
```

## ⚙️ Configuration

Copy the example file and customize:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Then edit `terraform.tfvars`:

```hcl
# Change environment
environment = "prod"

# Change instance sizes
node_instance_types = ["t3.large"]
db_instance_class   = "db.t3.small"

# Disable resources
create_rds       = false
create_s3_bucket = false
```

## 💰 Cost Considerations

| Resource | Estimated Monthly Cost (us-east-1) |
|----------|-----------------------------------|
| EKS Cluster | ~$73 |
| NAT Gateway | ~$32 + data transfer |
| t3.medium nodes (2x) | ~$60 |
| RDS db.t3.micro | ~$15 |
| S3 | Pay per use |
| **Total (dev)** | **~$180/month** |

To reduce costs:
- Set `enable_nat_gateway = false` (limits private subnet access)
- Reduce `node_desired_size = 1`
- Set `create_rds = false` (use MongoDB in K8s)

## 🔒 Security Best Practices

1. **State Management**: Use S3 backend with DynamoDB locking for production
2. **Secrets**: Never commit `terraform.tfvars` with sensitive values
3. **IAM**: Use least-privilege IAM roles
4. **Encryption**: All storage is encrypted by default
5. **Network**: Private subnets for databases and internal services

## 📊 Outputs

After `terraform apply`, you'll get:

- VPC and subnet IDs
- EKS cluster endpoint and name
- RDS endpoint and credentials (in Secrets Manager)
- S3 bucket name
- kubectl configuration command

## 🔧 Troubleshooting

### Common Issues

1. **EKS cluster creation timeout**: EKS takes 10-15 minutes to create
2. **NAT Gateway costs**: Consider using NAT instances for dev
3. **RDS password**: Auto-generated if not specified, stored in Secrets Manager

### Useful Commands

```bash
# Check Terraform state
terraform state list

# Import existing resource
terraform import aws_vpc.main vpc-xxxxxxxx

# Refresh state
terraform refresh

# Format code
terraform fmt -recursive
```
