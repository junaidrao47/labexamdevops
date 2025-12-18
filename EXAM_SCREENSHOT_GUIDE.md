# 📸 DevOps Exam - Complete Screenshot Guide

## Student: Junaid Rao
## Date: December 18, 2025

---

# 🚀 STEP-BY-STEP INSTRUCTIONS FOR EACH SECTION

---

## 📦 STEP 1: Project Selection and Containerization [Screenshots Needed]

### 1.1 Show Dockerfile (Multistage Build)
**Command:**
```powershell
# Open and show the Dockerfile content
Get-Content .\Dockerfile
```
📸 **Screenshot 1.1:** Take screenshot of Dockerfile showing multistage build

### 1.2 Build Docker Image
**Command:**
```powershell
# Build the Docker image
docker build -t node-redis-mongo:latest .
```
📸 **Screenshot 1.2:** Take screenshot of successful Docker build output

### 1.3 List Docker Images
**Command:**
```powershell
# Show the built image
docker images | Select-String "node-redis-mongo"
```
📸 **Screenshot 1.3:** Take screenshot showing the built image

### 1.4 Run Docker Compose (Local Testing)
**Command:**
```powershell
# Start all services
docker-compose up -d

# Wait for services to start
Start-Sleep -Seconds 10

# Verify all services are running
docker-compose ps
```
📸 **Screenshot 1.4:** Take screenshot of `docker-compose ps` showing all services running

### 1.5 Verify Container Networking
**Command:**
```powershell
# Check Docker networks
docker network ls

# Inspect the app network
docker network inspect node-redis-mongo_default
```
📸 **Screenshot 1.5:** Take screenshot showing container networking

### 1.6 Verify Persistent Storage (Volumes)
**Command:**
```powershell
# List Docker volumes
docker volume ls

# Inspect MongoDB volume
docker volume inspect node-redis-mongo_mongo-data
```
📸 **Screenshot 1.6:** Take screenshot showing persistent volumes for DB

### 1.7 Test the Application
**Command:**
```powershell
# Test health endpoint
curl http://localhost:5000/api/health

# Or in PowerShell:
Invoke-RestMethod -Uri http://localhost:5000/api/health
```
📸 **Screenshot 1.7:** Take screenshot showing successful API health check response

### 1.8 Show No Hardcoded Secrets (Environment Variables)
**Command:**
```powershell
# Show docker-compose.yml environment section
Get-Content .\docker-compose.yml
```
📸 **Screenshot 1.8:** Take screenshot showing environment variables (no hardcoded secrets)

---

## 🏗️ STEP 2: Infrastructure Provisioning with Terraform [10 Marks]

### 2.1 Show Terraform Files
**Command:**
```powershell
# Navigate to infra directory
cd infra

# List all terraform files
Get-ChildItem -Filter "*.tf"
```
📸 **Screenshot 2.1:** Take screenshot showing all .tf files in infra/

### 2.2 Initialize Terraform
**Command:**
```powershell
# Initialize Terraform
terraform init
```
📸 **Screenshot 2.2:** Take screenshot of successful terraform init

### 2.3 Validate Terraform Configuration
**Command:**
```powershell
# Validate the configuration
terraform validate
```
📸 **Screenshot 2.3:** Take screenshot showing "Success! The configuration is valid"

### 2.4 Show Terraform Plan
**Command:**
```powershell
# Generate execution plan
terraform plan
```
📸 **Screenshot 2.4:** Take screenshot of terraform plan output (showing resources to be created)

### 2.5 Apply Terraform (Create Resources)
**Command:**
```powershell
# Apply the infrastructure
terraform apply -auto-approve
```
📸 **Screenshot 2.5:** Take screenshot of terraform apply completion

### 2.6 Show Terraform Outputs
**Command:**
```powershell
# Show provisioned resources
terraform output
```
📸 **Screenshot 2.6:** Take screenshot of terraform output showing created resources

### 2.7 AWS Console Screenshot
📸 **Screenshot 2.7:** Login to AWS Console and take screenshots of:
- VPC Dashboard showing your VPC
- EC2 Dashboard showing instances (if EC2)
- EKS Console showing cluster (if EKS)
- S3 Console showing bucket
- RDS Console showing database (if RDS)

### 2.8 Terraform Destroy (Cleanup Proof)
**Command:**
```powershell
# Destroy all resources
terraform destroy -auto-approve
```
📸 **Screenshot 2.8:** Take screenshot of terraform destroy completion

**Return to project root:**
```powershell
cd ..
```

---

## ⚙️ STEP 4: Configuration Management with Ansible [5 Marks]

### 4.1 Show Ansible Files
**Command:**
```powershell
# Navigate to ansible directory
cd ansible

# List files
Get-ChildItem
```
📸 **Screenshot 4.1:** Take screenshot showing ansible files

### 4.2 Show Playbook Content
**Command:**
```powershell
# Show playbook
Get-Content .\playbook.yaml
```
📸 **Screenshot 4.2:** Take screenshot of playbook.yaml content

### 4.3 Show Inventory File
**Command:**
```powershell
# Show hosts inventory
Get-Content .\hosts.ini
```
📸 **Screenshot 4.3:** Take screenshot of hosts.ini content

### 4.4 Validate Ansible Playbook (Syntax Check)
**Command:**
```bash
# Check syntax (run in WSL or Linux)
ansible-playbook playbook.yaml --syntax-check
```
📸 **Screenshot 4.4:** Take screenshot of syntax check passing

### 4.5 Run Ansible Playbook (Dry Run)
**Command:**
```bash
# Dry run to check what would happen
ansible-playbook -i hosts.ini playbook.yaml --check
```
📸 **Screenshot 4.5:** Take screenshot of dry run output

### 4.6 Run Ansible Playbook (Actual Run)
**Command:**
```bash
# Actual playbook run against your servers
ansible-playbook -i hosts.ini playbook.yaml
```
📸 **Screenshot 4.6:** Take screenshot of successful playbook run with "ok" and "changed" counts

**Return to project root:**
```powershell
cd ..
```

---

## ☸️ STEP 5: Kubernetes Deployment [10 Marks]

### 5.1 Show Kubernetes Manifest Files
**Command:**
```powershell
# Navigate to k8s directory
cd k8s

# List all manifest files
Get-ChildItem -Filter "*.yaml"
```
📸 **Screenshot 5.1:** Take screenshot showing all K8s manifest files

### 5.2 Start Minikube (if using local Kubernetes)
**Command:**
```powershell
# Start Minikube
minikube start --driver=docker

# Verify Minikube is running
minikube status
```
📸 **Screenshot 5.2:** Take screenshot of Minikube running

### 5.3 Create Namespace
**Command:**
```powershell
# Apply namespace
kubectl apply -f namespace.yaml

# Show namespaces
kubectl get namespaces
```
📸 **Screenshot 5.3:** Take screenshot showing namespaces including your app namespace

### 5.4 Apply All Kubernetes Resources
**Command:**
```powershell
# Apply all configurations using Kustomize
kubectl apply -k .

# OR apply individually:
kubectl apply -f configmap.yaml
kubectl apply -f secret.yaml
kubectl apply -f mongo.yaml
kubectl apply -f redis.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f hpa.yaml
kubectl apply -f ingress.yaml
```
📸 **Screenshot 5.4:** Take screenshot of kubectl apply output

### 5.5 Get All Pods
**Command:**
```powershell
# Get all pods
kubectl get pods -n node-redis-mongo

# Watch pods status
kubectl get pods -n node-redis-mongo -w
```
📸 **Screenshot 5.5:** Take screenshot of `kubectl get pods` showing all pods RUNNING

### 5.6 Get All Services
**Command:**
```powershell
# Get all services
kubectl get svc -n node-redis-mongo
```
📸 **Screenshot 5.6:** Take screenshot of `kubectl get svc` showing all services

### 5.7 Describe Pod (Detailed Info)
**Command:**
```powershell
# Get pod name first
$POD_NAME = kubectl get pods -n node-redis-mongo -l app=node-redis-mongo -o jsonpath="{.items[0].metadata.name}"

# Describe the pod
kubectl describe pod $POD_NAME -n node-redis-mongo
```
📸 **Screenshot 5.7:** Take screenshot of `kubectl describe pod` output

### 5.8 Check Pod Logs
**Command:**
```powershell
# Get logs from the app pod
kubectl logs $POD_NAME -n node-redis-mongo
```
📸 **Screenshot 5.8:** Take screenshot showing application logs

### 5.9 Verify App Communication with DB
**Command:**
```powershell
# Port forward to access the app
kubectl port-forward svc/node-redis-mongo -n node-redis-mongo 5000:5000

# In another terminal, test the API
curl http://localhost:5000/api/health
```
📸 **Screenshot 5.9:** Take screenshot of successful health check via K8s

### 5.10 Show HPA (Horizontal Pod Autoscaler)
**Command:**
```powershell
# Show HPA
kubectl get hpa -n node-redis-mongo
```
📸 **Screenshot 5.10:** Take screenshot showing HPA configuration

**Return to project root:**
```powershell
cd ..
```

---

## 🔄 STEP 6: CI/CD Pipeline (GitHub Actions) [10 Marks]

### 6.1 Show GitHub Actions Workflow File
**Command:**
```powershell
# Show the CI/CD workflow
Get-Content .\.github\workflows\ci.yml
```
📸 **Screenshot 6.1:** Take screenshot of ci.yml content

### 6.2 Push Code to Trigger Pipeline
**Command:**
```powershell
# Add all changes
git add .

# Commit
git commit -m "DevOps exam - full pipeline demonstration"

# Push to trigger CI/CD
git push origin main
```
📸 **Screenshot 6.2:** Take screenshot of git push output

### 6.3 GitHub Actions Pipeline View
📸 **Screenshot 6.3:** Go to GitHub → Actions tab → Take screenshot showing:
- Pipeline running/completed
- All stages: Test, Security, Build, Deploy

### 6.4 Individual Stage Details
📸 **Screenshot 6.4:** Click on each stage and take screenshots of:
- 🧪 Test stage passing
- 🔒 Security scan results
- 🐳 Docker build & push success
- 🚀 Deployment stage

### 6.5 Pipeline Summary (All Stages Passed)
📸 **Screenshot 6.5:** Take screenshot of complete pipeline with ALL GREEN checkmarks

### 6.6 Docker Image in GitHub Container Registry
📸 **Screenshot 6.6:** Go to GitHub → Packages → Take screenshot showing pushed Docker image

---

## 📊 STEP 7: Monitoring & Observability (Grafana + Prometheus) [10 Marks]

### 7.1 Start Monitoring Stack
**Command:**
```powershell
# Ensure docker-compose services are running
docker-compose up -d prometheus grafana

# Verify monitoring services
docker-compose ps | Select-String "prometheus|grafana"
```
📸 **Screenshot 7.1:** Take screenshot showing Prometheus and Grafana containers running

### 7.2 Access Prometheus Dashboard
**Command:**
```powershell
# Prometheus runs on port 9090
Start-Process "http://localhost:9090"
```
📸 **Screenshot 7.2:** Take screenshot of Prometheus web UI

### 7.3 Prometheus Targets
📸 **Screenshot 7.3:** 
- Go to Prometheus → Status → Targets
- Take screenshot showing your app target is "UP"

### 7.4 Prometheus Metrics Query
📸 **Screenshot 7.4:** 
- In Prometheus, run a query like: `up` or `http_requests_total`
- Take screenshot of the metrics graph

### 7.5 Access Grafana Dashboard
**Command:**
```powershell
# Grafana runs on port 3000
Start-Process "http://localhost:3000"
# Default login: admin/admin
```
📸 **Screenshot 7.5:** Take screenshot of Grafana login/home page

### 7.6 Add Prometheus Data Source in Grafana
📸 **Screenshot 7.6:** 
- Go to Grafana → Configuration → Data Sources → Add Prometheus
- URL: http://prometheus:9090
- Take screenshot showing data source configured

### 7.7 Import/Create Dashboard
📸 **Screenshot 7.7:** 
- Import Node Exporter dashboard (ID: 1860) or create custom
- Take screenshot of the dashboard setup

### 7.8 Dashboard Metrics Visualization
📸 **Screenshot 7.8:** Take screenshots of Grafana dashboards showing:
- CPU Usage
- Memory Usage
- Request Count
- Response Times
- Container metrics

### 7.9 Show Prometheus Configuration
**Command:**
```powershell
# Show prometheus config
Get-Content .\prometheus\prometheus.yml
```
📸 **Screenshot 7.9:** Take screenshot of prometheus.yml configuration

---

## 📝 STEP 8: Documentation [5 Marks]

### 8.1 Show README.md
**Command:**
```powershell
# Show README content
Get-Content .\README.md
```
📸 **Screenshot 8.1:** Take screenshot of README.md content

### 8.2 Show devops_report.md
**Command:**
```powershell
# Show report content
Get-Content .\devops_report.md
```
📸 **Screenshot 8.2:** Take screenshot of devops_report.md content

---

# 🎯 QUICK REFERENCE - ALL COMMANDS IN SEQUENCE

```powershell
# ========================================
# STEP 1: Containerization
# ========================================
docker build -t node-redis-mongo:latest .
docker images
docker-compose up -d
docker-compose ps
docker network ls
docker volume ls
curl http://localhost:5000/api/health

# ========================================
# STEP 2: Terraform
# ========================================
cd infra
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
terraform output
# [Take AWS Console Screenshots]
terraform destroy -auto-approve
cd ..

# ========================================
# STEP 4: Ansible (run in WSL/Linux)
# ========================================
cd ansible
ansible-playbook playbook.yaml --syntax-check
ansible-playbook -i hosts.ini playbook.yaml --check
ansible-playbook -i hosts.ini playbook.yaml
cd ..

# ========================================
# STEP 5: Kubernetes
# ========================================
minikube start
cd k8s
kubectl apply -k .
kubectl get pods -n node-redis-mongo
kubectl get svc -n node-redis-mongo
kubectl describe pod <pod-name> -n node-redis-mongo
kubectl logs <pod-name> -n node-redis-mongo
cd ..

# ========================================
# STEP 6: CI/CD
# ========================================
git add .
git commit -m "DevOps exam submission"
git push origin main
# [Take GitHub Actions Screenshots]

# ========================================
# STEP 7: Monitoring
# ========================================
docker-compose up -d prometheus grafana
# Open http://localhost:9090 (Prometheus)
# Open http://localhost:3000 (Grafana)
# [Take Dashboard Screenshots]

# ========================================
# Cleanup
# ========================================
docker-compose down -v
minikube stop
```

---

# 📋 SCREENSHOT CHECKLIST

| Step | Description | Filename Suggestion | Done? |
|------|-------------|---------------------|-------|
| 1.1 | Dockerfile content | `01-dockerfile.png` | ☐ |
| 1.2 | Docker build success | `02-docker-build.png` | ☐ |
| 1.3 | Docker images list | `03-docker-images.png` | ☐ |
| 1.4 | Docker-compose ps | `04-compose-ps.png` | ☐ |
| 1.5 | Container networking | `05-docker-network.png` | ☐ |
| 1.6 | Persistent volumes | `06-docker-volumes.png` | ☐ |
| 1.7 | API health check | `07-health-check.png` | ☐ |
| 2.1 | Terraform files | `08-tf-files.png` | ☐ |
| 2.2 | Terraform init | `09-tf-init.png` | ☐ |
| 2.3 | Terraform validate | `10-tf-validate.png` | ☐ |
| 2.4 | Terraform plan | `11-tf-plan.png` | ☐ |
| 2.5 | Terraform apply | `12-tf-apply.png` | ☐ |
| 2.6 | Terraform output | `13-tf-output.png` | ☐ |
| 2.7 | AWS Console | `14-aws-console.png` | ☐ |
| 2.8 | Terraform destroy | `15-tf-destroy.png` | ☐ |
| 4.1 | Ansible files | `16-ansible-files.png` | ☐ |
| 4.2 | Playbook content | `17-playbook.png` | ☐ |
| 4.3 | Inventory file | `18-inventory.png` | ☐ |
| 4.4 | Ansible syntax check | `19-ansible-syntax.png` | ☐ |
| 4.5 | Ansible playbook run | `20-ansible-run.png` | ☐ |
| 5.1 | K8s manifest files | `21-k8s-files.png` | ☐ |
| 5.2 | Minikube status | `22-minikube.png` | ☐ |
| 5.3 | Kubectl get namespaces | `23-namespaces.png` | ☐ |
| 5.4 | Kubectl apply | `24-k8s-apply.png` | ☐ |
| 5.5 | Kubectl get pods | `25-get-pods.png` | ☐ |
| 5.6 | Kubectl get svc | `26-get-svc.png` | ☐ |
| 5.7 | Kubectl describe pod | `27-describe-pod.png` | ☐ |
| 5.8 | Pod logs | `28-pod-logs.png` | ☐ |
| 5.9 | K8s health check | `29-k8s-health.png` | ☐ |
| 5.10 | HPA status | `30-hpa.png` | ☐ |
| 6.1 | CI/CD workflow file | `31-workflow-file.png` | ☐ |
| 6.2 | Git push | `32-git-push.png` | ☐ |
| 6.3 | GitHub Actions view | `33-actions-view.png` | ☐ |
| 6.4 | Pipeline stages | `34-pipeline-stages.png` | ☐ |
| 6.5 | All stages passed | `35-pipeline-success.png` | ☐ |
| 6.6 | Docker image in GHCR | `36-ghcr-image.png` | ☐ |
| 7.1 | Monitoring services | `37-monitoring-services.png` | ☐ |
| 7.2 | Prometheus UI | `38-prometheus-ui.png` | ☐ |
| 7.3 | Prometheus targets | `39-prometheus-targets.png` | ☐ |
| 7.4 | Prometheus metrics | `40-prometheus-metrics.png` | ☐ |
| 7.5 | Grafana home | `41-grafana-home.png` | ☐ |
| 7.6 | Grafana data source | `42-grafana-datasource.png` | ☐ |
| 7.7 | Dashboard setup | `43-dashboard-setup.png` | ☐ |
| 7.8 | Dashboard metrics | `44-dashboard-metrics.png` | ☐ |
| 8.1 | README.md | `45-readme.png` | ☐ |
| 8.2 | devops_report.md | `46-report.png` | ☐ |

---

# 💡 TIPS

1. **Use Windows + Shift + S** for quick screenshots on Windows
2. **Name files systematically** (e.g., `01-step1-dockerfile.png`)
3. **Create a `screenshots/` folder** to organize all images
4. **Capture full terminal output** showing successful completion
5. **For AWS Console**, make sure your username is visible in screenshots
6. **For Grafana**, generate some traffic first to show metrics

Good luck with your exam! 🚀
