# 🚀 DevOps Lab Exam - Node.js Redis MongoDB Application

> **Complete DevOps Implementation Guide**  
> Student: Junaid Rao | Repository: [labexamdevops](https://github.com/junaidrao47/labexamdevops)

---

## 📋 Table of Contents

1. [Project Overview](#-project-overview)
2. [Architecture Diagram](#-architecture-diagram)
3. [Step 1: Containerization (Dockerfile)](#-step-1-containerization)
4. [Step 2: Terraform Infrastructure (AWS)](#%EF%B8%8F-step-2-terraform-infrastructure-aws)
5. [Step 4: Ansible Configuration Management](#-step-4-ansible-configuration-management)
6. [Step 5: Kubernetes Deployment](#%EF%B8%8F-step-5-kubernetes-deployment)
7. [Step 6: CI/CD Pipeline](#-step-6-cicd-pipeline)
8. [Step 7: Monitoring (Prometheus + Grafana)](#-step-7-monitoring)
9. [Step 8: Documentation](#-step-8-documentation)
10. [Quick Start Guide](#-quick-start-guide)
11. [API Reference](#-api-reference)
12. [Troubleshooting](#-troubleshooting)

---

## 🎯 Project Overview

This project demonstrates a **production-ready DevOps implementation** for a Node.js application with:

| Component | Technology |
|-----------|------------|
| **Backend** | Node.js 18 + Express.js |
| **Database** | MongoDB 6.0 |
| **Cache** | Redis 7.0 |
| **Container** | Docker + Docker Compose |
| **Orchestration** | Kubernetes (Minikube/EKS) |
| **Infrastructure** | Terraform (AWS) |
| **Configuration** | Ansible |
| **CI/CD** | GitHub Actions |
| **Monitoring** | Prometheus + Grafana |

### Exam Scoring (50 Marks Total)

| Step | Component | Marks | Status |
|------|-----------|-------|--------|
| 1 | Containerization | ✅ | Done |
| 2 | Terraform Infrastructure | 10 | Done |
| 4 | Ansible Configuration | 5 | Done |
| 5 | Kubernetes Deployment | 10 | Done |
| 6 | CI/CD Pipeline | 10 | Done |
| 7 | Monitoring Screenshots | 10 | Done |
| 8 | Documentation | 5 | Done |

---

## 🏗️ Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                         GITHUB ACTIONS CI/CD                         │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐  │
│  │  Lint &  │→│ Security │→│  Build   │→│  Smoke   │→│  Deploy  │  │
│  │   Test   │ │   Scan   │ │  Docker  │ │  Tests   │ │   K8s    │  │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘ └──────────┘  │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      AWS INFRASTRUCTURE (Terraform)                  │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │                    VPC (10.0.0.0/16)                          │  │
│  │  ┌─────────────────┐              ┌─────────────────┐        │  │
│  │  │ Public Subnet 1 │              │ Public Subnet 2 │        │  │
│  │  │   10.0.1.0/24   │              │   10.0.2.0/24   │        │  │
│  │  │  ┌───────────┐  │              │  ┌───────────┐  │        │  │
│  │  │  │EC2/Docker │  │              │  │NAT Gateway│  │        │  │
│  │  │  └───────────┘  │              │  └───────────┘  │        │  │
│  │  └─────────────────┘              └─────────────────┘        │  │
│  │  ┌─────────────────┐              ┌─────────────────┐        │  │
│  │  │Private Subnet 1 │              │Private Subnet 2 │        │  │
│  │  │  10.0.10.0/24   │              │  10.0.20.0/24   │        │  │
│  │  └─────────────────┘              └─────────────────┘        │  │
│  └───────────────────────────────────────────────────────────────┘  │
│  ┌─────────────────┐  ┌─────────────────┐                          │
│  │   S3 Bucket     │  │ Security Groups │                          │
│  └─────────────────┘  └─────────────────┘                          │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    KUBERNETES CLUSTER (Minikube/EKS)                 │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │  Namespace: dev                                                 │ │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │ │
│  │  │  ConfigMap   │  │    Secret    │  │     HPA      │         │ │
│  │  └──────────────┘  └──────────────┘  └──────────────┘         │ │
│  │  ┌──────────────────────────────────────────────────────────┐ │ │
│  │  │                    Deployment (2 replicas)                │ │ │
│  │  │  ┌─────────┐  ┌─────────┐                                │ │ │
│  │  │  │  Pod 1  │  │  Pod 2  │                                │ │ │
│  │  │  │ NodeApp │  │ NodeApp │                                │ │ │
│  │  │  └─────────┘  └─────────┘                                │ │ │
│  │  └──────────────────────────────────────────────────────────┘ │ │
│  │  ┌──────────────┐  ┌──────────────┐                          │ │
│  │  │   MongoDB    │  │    Redis     │                          │ │
│  │  │  StatefulSet │  │  StatefulSet │                          │ │
│  │  └──────────────┘  └──────────────┘                          │ │
│  │  ┌──────────────────────────────────────────────────────────┐ │ │
│  │  │  Service: NodePort (30500) + ClusterIP                   │ │ │
│  │  └──────────────────────────────────────────────────────────┘ │ │
│  └────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                         MONITORING STACK                             │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐  │
│  │   Prometheus    │───▶│     Grafana     │───▶│   Dashboards    │  │
│  │   Port: 9090    │    │   Port: 3000    │    │   & Alerts      │  │
│  └─────────────────┘    └─────────────────┘    └─────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 🐳 Step 1: Containerization

### Dockerfile (Multistage Build)

**Location:** `Dockerfile`

```dockerfile
# ============================================
# Stage 1: Builder
# ============================================
FROM node:18-alpine AS builder
WORKDIR /app
RUN apk add --no-cache python3 make g++
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

# ============================================
# Stage 2: Production
# ============================================
FROM node:18-alpine AS production

# Install dumb-init for proper signal handling
RUN apk add --no-cache dumb-init curl

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001 -G nodejs

WORKDIR /app

# Copy from builder
COPY --from=builder --chown=nodejs:nodejs /app/node_modules ./node_modules
COPY --chown=nodejs:nodejs . .

# Switch to non-root user
USER nodejs

EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:5000/api/health || exit 1

# Labels
LABEL maintainer="junaidrao47"
LABEL version="1.0"

# Start with dumb-init
ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "index.js"]
```

### Docker Compose

**Location:** `docker-compose.yml`

```yaml
version: "3"
services:
  mongo:
    image: "mongo:latest"
    ports:
      - "27018:27017"
    volumes:
      - mongo-data:/data/db

  redis:
    image: "redis:latest"
    restart: unless-stopped
    volumes:
      - redis-data:/data

  server:
    ports:
      - "5000:5000"
    build:
      dockerfile: Dockerfile
      context: ./
    environment:
      - REDIS_HOST=redis
      - REDIS_PORT=6379
      - MONGO_DB_NAME=library
      - MONGO_PORT=27017
      - MONGO_HOST=mongo
    depends_on:
      - mongo
      - redis
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:5000/api/health || exit 1"]
      interval: 10s
      timeout: 5s
      retries: 5

  prometheus:
    image: prom/prometheus:latest
    volumes:
      - ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml:ro
    ports:
      - "9090:9090"

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    restart: unless-stopped

volumes:
  mongo-data:
  redis-data:
```

### Commands to Run

```powershell
# Build and start all services
docker-compose up --build -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f server

# Stop all services
docker-compose down

# Verify application
curl http://localhost:5000/api/health
# Response: {"status":"ok"}
```

---

## ☁️ Step 2: Terraform Infrastructure (AWS)

### Directory Structure

```
infra/
├── main.tf              # Provider configuration
├── variables.tf         # Input variables
├── terraform.tfvars     # Variable values
├── vpc.tf               # VPC, subnets, NAT, routing
├── security-groups.tf   # 6 security groups
├── eks.tf               # EKS cluster (optional)
├── ec2.tf               # EC2 fallback instance
├── rds.tf               # RDS PostgreSQL
├── s3.tf                # S3 bucket with lifecycle
├── outputs.tf           # Output values
└── README.md            # Documentation
```

### main.tf

```hcl
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Owner       = var.owner
    }
  }
}
```

### terraform.tfvars

```hcl
project_name = "node-redis-mongo"
environment  = "dev"
owner        = "junaidrao47"
aws_region   = "ap-southeast-1"

vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.20.0/24"]
enable_nat_gateway   = true
single_nat_gateway   = true

use_ec2_fallback  = true
ec2_instance_type = "t3.micro"
create_s3_bucket  = true
```

### Commands to Run

```powershell
cd infra/

# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Preview changes
terraform plan -out=plan.out

# Apply infrastructure
terraform apply plan.out

# View outputs
terraform output

# IMPORTANT: Destroy to avoid costs
terraform destroy -auto-approve
```

### Resources Created

| Resource | Description |
|----------|-------------|
| **VPC** | 10.0.0.0/16 with DNS support |
| **Subnets** | 2 public + 2 private across AZs |
| **NAT Gateway** | For private subnet internet access |
| **Security Groups** | 6 SGs (EKS, nodes, app, DB, cache, EC2) |
| **EC2 Instance** | t3.micro with Docker pre-installed |
| **S3 Bucket** | Versioned with lifecycle rules |

### Sample Terraform Output

```
vpc_id = "vpc-041c9b00ad7fd5d44"
ec2_public_ip = "52.221.212.142"
s3_bucket_name = "node-redis-mongo-storage-dev-350063aa"
nat_gateway_ips = ["54.255.137.225"]
```

---

## 🔧 Step 4: Ansible Configuration Management

### Directory Structure

```
ansible/
├── ansible.cfg          # Ansible configuration
├── hosts.ini            # Inventory file
├── playbook.yaml        # Main playbook
├── requirements.yaml    # Galaxy dependencies
├── README.md            # Documentation
├── group_vars/
│   ├── all.yaml         # Global variables
│   └── vault.yaml       # Encrypted secrets
└── templates/
    └── env.j2           # Environment file template
```

### hosts.ini (Inventory)

```ini
[webservers]
app-server-1 ansible_host=52.221.212.142 ansible_user=ec2-user

[local]
localhost ansible_connection=local

[all:vars]
ansible_python_interpreter=/usr/bin/python3
environment=dev
project_name=node-redis-mongo

[webservers:vars]
node_version=18
app_port=5000
app_user=nodejs
```

### playbook.yaml (Key Tasks)

```yaml
---
- name: Configure Application Servers
  hosts: webservers
  become: true
  
  tasks:
    # System Preparation
    - name: Install required packages
      package:
        name: [git, curl, wget, docker, nodejs]
        state: present

    # Docker Installation
    - name: Start Docker service
      service:
        name: docker
        state: started
        enabled: yes

    # Application Deployment
    - name: Clone repository
      git:
        repo: "https://github.com/junaidrao47/labexamdevops.git"
        dest: /opt/node-redis-mongo

    - name: Install npm dependencies
      npm:
        path: /opt/node-redis-mongo
        state: present

    # Start Application
    - name: Start with Docker Compose
      community.docker.docker_compose_v2:
        project_src: /opt/node-redis-mongo
        state: present

    # Monitoring
    - name: Install Node Exporter
      get_url:
        url: "https://github.com/prometheus/node_exporter/releases/..."
        dest: /opt/node_exporter
```

### Commands to Run

```powershell
cd ansible/

# Test connectivity
ansible all -m ping -i hosts.ini

# Syntax check
ansible-playbook playbook.yaml --syntax-check

# Dry run
ansible-playbook playbook.yaml --check

# Run playbook
ansible-playbook playbook.yaml

# Run with vault password
ansible-playbook playbook.yaml --ask-vault-pass
```

---

## ☸️ Step 5: Kubernetes Deployment

### Directory Structure

```
k8s/
├── namespace.yaml       # dev/prod namespaces + ResourceQuota
├── configmap.yaml       # Application configuration
├── secret.yaml          # Base64 encoded secrets
├── deployment.yaml      # App deployment with probes
├── service.yaml         # NodePort (30500) + ClusterIP
├── mongo.yaml           # MongoDB StatefulSet + PVC
├── redis.yaml           # Redis StatefulSet + PVC
├── hpa.yaml             # Horizontal Pod Autoscaler
├── ingress.yaml         # Ingress rules
└── kustomization.yaml   # Kustomize configuration
```

### namespace.yaml

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: dev
  labels:
    environment: development
---
apiVersion: v1
kind: ResourceQuota
metadata:
  name: dev-quota
  namespace: dev
spec:
  hard:
    requests.cpu: "4"
    requests.memory: 8Gi
    pods: "20"
```

### deployment.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: node-redis-mongo
  namespace: dev
spec:
  replicas: 2
  selector:
    matchLabels:
      app: node-redis-mongo
  template:
    metadata:
      labels:
        app: node-redis-mongo
    spec:
      containers:
      - name: app
        image: ghcr.io/junaidrao47/labexamdevops:latest
        ports:
        - containerPort: 5000
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /api/health
            port: 5000
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /api/health
            port: 5000
          initialDelaySeconds: 5
          periodSeconds: 5
```

### service.yaml

```yaml
apiVersion: v1
kind: Service
metadata:
  name: node-redis-mongo-service
  namespace: dev
spec:
  type: NodePort
  selector:
    app: node-redis-mongo
  ports:
  - port: 5000
    targetPort: 5000
    nodePort: 30500
```

### Commands to Run

```powershell
# Start Minikube
minikube start --driver=docker

# Apply all manifests
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/secret.yaml
kubectl apply -f k8s/mongo.yaml
kubectl apply -f k8s/redis.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/hpa.yaml

# Check status
kubectl get all -n dev
kubectl get pods -n dev
kubectl get svc -n dev

# Access application
minikube service node-redis-mongo-service -n dev

# View logs
kubectl logs -f deployment/node-redis-mongo -n dev
```

### Expected Output

```
NAME                                   READY   STATUS    AGE
pod/mongodb-0                          1/1     Running   5m
pod/node-redis-mongo-xxx-yyy           1/1     Running   5m
pod/redis-0                            1/1     Running   5m

NAME                               TYPE        PORT(S)
service/node-redis-mongo-service   NodePort    5000:30500/TCP
```

---

## 🚀 Step 6: CI/CD Pipeline

### Pipeline Visualization

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  🧪 Lint &   │────▶│  🔒 Security │────▶│  🐳 Build &  │
│     Test     │     │     Scan     │     │  Push Docker │
│    (31s)     │     │    (18s)     │     │   (2m 57s)   │
└──────────────┘     └──────────────┘     └──────────────┘
                                                 │
        ┌────────────────────────────────────────┼────────────────┐
        │                                        │                │
        ▼                                        ▼                ▼
┌──────────────┐                         ┌──────────────┐  ┌──────────────┐
│  🏗️ Terraform │                         │  🔥 Smoke    │  │  📋 Ansible  │
│     Plan     │                         │    Tests     │  │     Lint     │
└──────────────┘                         └──────────────┘  └──────────────┘
        │                                        │                │
        └────────────────────────────────────────┼────────────────┘
                                                 ▼
                                         ┌──────────────┐
                                         │  🚀 Deploy   │
                                         │   to K8s     │
                                         └──────────────┘
                                                 ▼
                                         ┌──────────────┐
                                         │  📊 Pipeline │
                                         │   Summary    │
                                         └──────────────┘
```

### Pipeline Stages

| Stage | Description | Time |
|-------|-------------|------|
| 🧪 **Lint & Test** | ESLint + Jest tests | 31s |
| 🔒 **Security Scan** | Trivy vulnerability scanner | 18s |
| 🐳 **Build & Push** | Docker multi-platform build | 2m 57s |
| 🏗️ **Terraform Plan** | Infrastructure validation | 17s |
| 📋 **Ansible Lint** | Playbook syntax check | 37s |
| 🔥 **Smoke Tests** | API endpoint validation | 36s |
| 🚀 **Deploy to K8s** | Kubernetes deployment | 11s |
| 📊 **Summary** | Pipeline results | 2s |

### View Pipeline

- **URL:** https://github.com/junaidrao47/labexamdevops/actions
- **Status:** All stages should show ✅ green checkmarks

---

## 📊 Step 7: Monitoring

### Start Monitoring Stack

```powershell
docker-compose up -d prometheus grafana
```

### Access URLs

| Service | URL | Credentials |
|---------|-----|-------------|
| **Prometheus** | http://localhost:9090 | - |
| **Grafana** | http://localhost:3000 | admin / admin |

### Grafana Setup Guide

#### 1. Login to Grafana
- Open http://localhost:3000
- Username: `admin`
- Password: `admin`

#### 2. Add Prometheus Data Source
1. Click **⚙️ Settings** → **Data Sources**
2. Click **Add data source**
3. Select **Prometheus**
4. Set URL: `http://prometheus:9090`
5. Click **Save & Test** → Should show ✅

#### 3. Import Dashboard
1. Click **+** → **Import**
2. Enter Dashboard ID: `1860` (Node Exporter Full)
3. Select Prometheus data source
4. Click **Import**

### Prometheus Queries

```promql
# Check running services
up

# CPU usage
rate(process_cpu_seconds_total[5m])

# Memory usage
process_resident_memory_bytes / 1024 / 1024
```

### Screenshots to Capture

1. **Prometheus Targets** - http://localhost:9090/targets
2. **Prometheus Graph** - Run query `up`
3. **Grafana Dashboard** - Imported dashboard
4. **Grafana Data Source** - Prometheus connected

---

## 📖 Step 8: Documentation

### Files Created/Updated

| File | Purpose |
|------|---------|
| `README.md` | This comprehensive guide |
| `devops_report.md` | Technical architecture report |
| `infra/README.md` | Terraform documentation |
| `ansible/README.md` | Ansible documentation |

---

## 🚀 Quick Start Guide

### Option 1: Docker Compose (Quickest)

```powershell
git clone https://github.com/junaidrao47/labexamdevops.git
cd labexamdevops/node-redis-mongo
docker-compose up --build -d
curl http://localhost:5000/api/health
```

### Option 2: Kubernetes (Minikube)

```powershell
minikube start
kubectl apply -f k8s/
minikube service node-redis-mongo-service -n dev
```

### Option 3: AWS (Terraform)

```powershell
cd infra/
terraform init
terraform apply
# After testing:
terraform destroy
```

---

## 📡 API Reference

### Health Check

```http
GET /api/health
Response: {"status": "ok"}
```

### Todos API

```http
GET    /api/todos          # List all
POST   /api/todos          # Create
PUT    /api/todos/:id      # Update
DELETE /api/todos/:id      # Delete
```

### Books API

```http
GET    /api/books          # List all
POST   /api/books          # Create
PUT    /api/books/:id      # Update
DELETE /api/books/:id      # Delete
```

### Example

```bash
curl -X POST http://localhost:5000/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title": "Learn DevOps"}'
```

---

## 🔧 Troubleshooting

### Docker Issues

```powershell
docker-compose logs -f server
docker-compose restart
docker-compose down -v && docker-compose up --build
```

### Kubernetes Issues

```powershell
kubectl get pods -n dev
kubectl describe pod <pod-name> -n dev
kubectl logs <pod-name> -n dev
```

### Terraform Issues

```powershell
terraform refresh
terraform destroy -target=<resource>
rm -rf .terraform && terraform init
```

---

## 📝 Submission Checklist

- [x] **Step 1:** Dockerfile with multistage build
- [x] **Step 2:** Terraform infrastructure (VPC, EC2, S3)
- [x] **Step 4:** Ansible playbook and inventory
- [x] **Step 5:** Kubernetes manifests (all files)
- [x] **Step 6:** CI/CD pipeline (7 stages)
- [x] **Step 7:** Monitoring (Prometheus + Grafana)
- [x] **Step 8:** Documentation (README + report)

---

## 👤 Author

**Junaid Rao**
- GitHub: [@junaidrao47](https://github.com/junaidrao47)
- Repository: [labexamdevops](https://github.com/junaidrao47/labexamdevops)

---

## 📄 License

MIT License

---

**Total Marks: 50** | **All Steps Completed ✅**
