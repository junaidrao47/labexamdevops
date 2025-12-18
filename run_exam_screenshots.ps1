# ============================================
# DevOps Exam - Screenshot Runner Script
# Run each section and take screenshots
# ============================================

Write-Host @"
╔══════════════════════════════════════════════════════════════╗
║           DEVOPS EXAM - SCREENSHOT CAPTURE GUIDE             ║
║                   Student: Junaid Rao                        ║
╚══════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

$projectPath = "e:\LAB-DEVOPS-MID\node-redis-mongo"
Set-Location $projectPath

function Wait-ForScreenshot {
    param([string]$stepName)
    Write-Host "`n📸 SCREENSHOT NOW: $stepName" -ForegroundColor Yellow
    Write-Host "Press any key to continue..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Show-Header {
    param([string]$step, [string]$title)
    Write-Host "`n" + "="*60 -ForegroundColor DarkCyan
    Write-Host "  $step : $title" -ForegroundColor Cyan
    Write-Host "="*60 -ForegroundColor DarkCyan
}

# ============================================
# STEP 1: CONTAINERIZATION
# ============================================
Show-Header "STEP 1.1" "Dockerfile (Multistage Build)"
Get-Content .\Dockerfile
Wait-ForScreenshot "Screenshot showing Dockerfile content"

Show-Header "STEP 1.2" "Building Docker Image"
docker build -t node-redis-mongo:latest .
Wait-ForScreenshot "Screenshot showing successful Docker build"

Show-Header "STEP 1.3" "Docker Images List"
docker images | Select-String "node-redis-mongo|REPOSITORY"
Wait-ForScreenshot "Screenshot showing built image"

Show-Header "STEP 1.4" "Docker Compose - Starting Services"
docker-compose up -d
Start-Sleep -Seconds 5
docker-compose ps
Wait-ForScreenshot "Screenshot showing all services running"

Show-Header "STEP 1.5" "Container Networking"
docker network ls
Write-Host "`n--- Network Details ---"
docker network inspect node-redis-mongo_default 2>$null | ConvertFrom-Json | Select-Object Name, Driver | Format-Table
Wait-ForScreenshot "Screenshot showing Docker networks"

Show-Header "STEP 1.6" "Persistent Volumes"
docker volume ls
Wait-ForScreenshot "Screenshot showing Docker volumes for persistence"

Show-Header "STEP 1.7" "API Health Check"
Start-Sleep -Seconds 5
try {
    $health = Invoke-RestMethod -Uri http://localhost:5000/api/health -TimeoutSec 10
    Write-Host "Health Check Response:" -ForegroundColor Green
    $health | ConvertTo-Json
} catch {
    Write-Host "Trying with curl..."
    curl.exe http://localhost:5000/api/health
}
Wait-ForScreenshot "Screenshot showing successful health check"

Show-Header "STEP 1.8" "Environment Variables (No Hardcoded Secrets)"
Get-Content .\docker-compose.yml | Select-String -Pattern "environment|REDIS|MONGO|SECRET" -Context 0,5
Wait-ForScreenshot "Screenshot showing env vars (no secrets)"

Write-Host "`n✅ STEP 1 COMPLETE - Containerization Screenshots Done!" -ForegroundColor Green

# ============================================
# STEP 2: TERRAFORM
# ============================================
Show-Header "STEP 2.1" "Terraform Files"
Set-Location "$projectPath\infra"
Get-ChildItem -Filter "*.tf" | Format-Table Name, Length, LastWriteTime
Wait-ForScreenshot "Screenshot showing .tf files"

Show-Header "STEP 2.2" "Terraform Init"
terraform init
Wait-ForScreenshot "Screenshot showing terraform init success"

Show-Header "STEP 2.3" "Terraform Validate"
terraform validate
Wait-ForScreenshot "Screenshot showing validation success"

Show-Header "STEP 2.4" "Terraform Plan"
terraform plan
Wait-ForScreenshot "Screenshot showing terraform plan output"

Write-Host "`n⚠️  IMPORTANT: The next step will CREATE REAL AWS RESOURCES and COST MONEY!" -ForegroundColor Red
Write-Host "Only run 'terraform apply' if you have AWS credentials configured and budget approval." -ForegroundColor Yellow
$confirm = Read-Host "Do you want to run terraform apply? (yes/no)"

if ($confirm -eq "yes") {
    Show-Header "STEP 2.5" "Terraform Apply"
    terraform apply -auto-approve
    Wait-ForScreenshot "Screenshot showing terraform apply success"
    
    Show-Header "STEP 2.6" "Terraform Outputs"
    terraform output
    Wait-ForScreenshot "Screenshot showing terraform outputs"
    
    Write-Host "`n📸 NOW GO TO AWS CONSOLE AND TAKE SCREENSHOTS OF:" -ForegroundColor Yellow
    Write-Host "   - VPC Dashboard" -ForegroundColor White
    Write-Host "   - EC2 Instances (if created)" -ForegroundColor White
    Write-Host "   - EKS Cluster (if created)" -ForegroundColor White
    Write-Host "   - S3 Buckets" -ForegroundColor White
    Wait-ForScreenshot "Screenshots from AWS Console"
    
    Show-Header "STEP 2.7" "Terraform Destroy (Cleanup)"
    terraform destroy -auto-approve
    Wait-ForScreenshot "Screenshot showing terraform destroy success"
}

Set-Location $projectPath
Write-Host "`n✅ STEP 2 COMPLETE - Terraform Screenshots Done!" -ForegroundColor Green

# ============================================
# STEP 4: ANSIBLE (Note: Requires WSL or Linux)
# ============================================
Show-Header "STEP 4.1" "Ansible Files"
Set-Location "$projectPath\ansible"
Get-ChildItem
Wait-ForScreenshot "Screenshot showing ansible directory"

Show-Header "STEP 4.2" "Playbook Content"
Get-Content .\playbook.yaml | Select-Object -First 80
Wait-ForScreenshot "Screenshot showing playbook.yaml"

Show-Header "STEP 4.3" "Inventory File"
Get-Content .\hosts.ini
Wait-ForScreenshot "Screenshot showing hosts.ini"

Write-Host "`n⚠️  Ansible requires Linux/WSL. Run these commands in WSL:" -ForegroundColor Yellow
Write-Host "   cd /mnt/e/LAB-DEVOPS-MID/node-redis-mongo/ansible" -ForegroundColor White
Write-Host "   ansible-playbook playbook.yaml --syntax-check" -ForegroundColor White
Write-Host "   ansible-playbook -i hosts.ini playbook.yaml --check" -ForegroundColor White
Wait-ForScreenshot "Screenshot of ansible commands in WSL"

Set-Location $projectPath
Write-Host "`n✅ STEP 4 COMPLETE - Ansible Screenshots Done!" -ForegroundColor Green

# ============================================
# STEP 5: KUBERNETES
# ============================================
Show-Header "STEP 5.1" "Kubernetes Manifest Files"
Set-Location "$projectPath\k8s"
Get-ChildItem -Filter "*.yaml" | Format-Table Name, Length
Wait-ForScreenshot "Screenshot showing K8s manifests"

Show-Header "STEP 5.2" "Start Minikube"
minikube start --driver=docker
minikube status
Wait-ForScreenshot "Screenshot showing Minikube running"

Show-Header "STEP 5.3" "Create Namespaces"
kubectl apply -f namespace.yaml
kubectl get namespaces
Wait-ForScreenshot "Screenshot showing namespaces"

Show-Header "STEP 5.4" "Apply All K8s Resources"
kubectl apply -k .
Wait-ForScreenshot "Screenshot showing kubectl apply output"

Show-Header "STEP 5.5" "Get Pods"
Start-Sleep -Seconds 10
kubectl get pods -A | Select-String "node-redis-mongo|NAME"
Wait-ForScreenshot "Screenshot showing pods"

Show-Header "STEP 5.6" "Get Services"
kubectl get svc -A | Select-String "node-redis-mongo|NAME"
Wait-ForScreenshot "Screenshot showing services"

Show-Header "STEP 5.7" "Describe Pod"
$podName = kubectl get pods -l app=node-redis-mongo -o jsonpath="{.items[0].metadata.name}" 2>$null
if ($podName) {
    kubectl describe pod $podName
    Wait-ForScreenshot "Screenshot showing pod description"
}

Show-Header "STEP 5.8" "Pod Logs"
if ($podName) {
    kubectl logs $podName
    Wait-ForScreenshot "Screenshot showing pod logs"
}

Show-Header "STEP 5.9" "HPA Status"
kubectl get hpa -A
Wait-ForScreenshot "Screenshot showing HPA"

Set-Location $projectPath
Write-Host "`n✅ STEP 5 COMPLETE - Kubernetes Screenshots Done!" -ForegroundColor Green

# ============================================
# STEP 6: CI/CD (GitHub Actions)
# ============================================
Show-Header "STEP 6.1" "GitHub Actions Workflow"
Get-Content ".\.github\workflows\ci.yml" | Select-Object -First 100
Wait-ForScreenshot "Screenshot showing workflow file"

Write-Host "`n📸 FOR GITHUB ACTIONS, DO THE FOLLOWING:" -ForegroundColor Yellow
Write-Host "   1. git add . && git commit -m 'DevOps exam' && git push" -ForegroundColor White
Write-Host "   2. Go to: https://github.com/junaidrao47/labexamdevops/actions" -ForegroundColor White
Write-Host "   3. Take screenshot of pipeline running" -ForegroundColor White
Write-Host "   4. Take screenshot of each stage" -ForegroundColor White
Write-Host "   5. Take screenshot of all stages passed (green)" -ForegroundColor White
Wait-ForScreenshot "GitHub Actions screenshots"

Write-Host "`n✅ STEP 6 COMPLETE - CI/CD Screenshots Done!" -ForegroundColor Green

# ============================================
# STEP 7: MONITORING
# ============================================
Show-Header "STEP 7.1" "Start Prometheus & Grafana"
Set-Location $projectPath
docker-compose up -d prometheus grafana
Start-Sleep -Seconds 5
docker-compose ps | Select-String "prometheus|grafana|NAME"
Wait-ForScreenshot "Screenshot showing monitoring services"

Show-Header "STEP 7.2" "Prometheus Configuration"
Get-Content .\prometheus\prometheus.yml
Wait-ForScreenshot "Screenshot showing prometheus.yml"

Write-Host "`n📸 MONITORING SCREENSHOTS - Open these URLs:" -ForegroundColor Yellow
Write-Host "   Prometheus: http://localhost:9090" -ForegroundColor Cyan
Write-Host "   Grafana:    http://localhost:3000 (admin/admin)" -ForegroundColor Cyan
Start-Process "http://localhost:9090"
Start-Process "http://localhost:3000"

Write-Host "`n📸 PROMETHEUS SCREENSHOTS TO TAKE:" -ForegroundColor Yellow
Write-Host "   1. Prometheus homepage" -ForegroundColor White
Write-Host "   2. Status -> Targets (showing UP status)" -ForegroundColor White
Write-Host "   3. Graph with a query like 'up' or 'http_requests_total'" -ForegroundColor White
Wait-ForScreenshot "Prometheus screenshots"

Write-Host "`n📸 GRAFANA SCREENSHOTS TO TAKE:" -ForegroundColor Yellow
Write-Host "   1. Login page / Home dashboard" -ForegroundColor White
Write-Host "   2. Configuration -> Data Sources -> Add Prometheus" -ForegroundColor White
Write-Host "   3. Import Dashboard (ID: 1860 for Node Exporter)" -ForegroundColor White
Write-Host "   4. Dashboard showing CPU, Memory metrics" -ForegroundColor White
Wait-ForScreenshot "Grafana screenshots"

Write-Host "`n✅ STEP 7 COMPLETE - Monitoring Screenshots Done!" -ForegroundColor Green

# ============================================
# STEP 8: DOCUMENTATION
# ============================================
Show-Header "STEP 8.1" "README.md"
Get-Content .\README.md | Select-Object -First 50
Wait-ForScreenshot "Screenshot showing README.md"

Show-Header "STEP 8.2" "devops_report.md"
Get-Content .\devops_report.md | Select-Object -First 50
Wait-ForScreenshot "Screenshot showing devops_report.md"

Write-Host "`n✅ STEP 8 COMPLETE - Documentation Screenshots Done!" -ForegroundColor Green

# ============================================
# CLEANUP
# ============================================
Write-Host "`n" + "="*60 -ForegroundColor Green
Write-Host "  🎉 ALL SCREENSHOTS COMPLETE!" -ForegroundColor Green
Write-Host "="*60 -ForegroundColor Green

Write-Host "`n🧹 CLEANUP COMMANDS:" -ForegroundColor Yellow
Write-Host "   docker-compose down -v" -ForegroundColor White
Write-Host "   minikube stop" -ForegroundColor White
Write-Host "   minikube delete" -ForegroundColor White

Write-Host "`n📁 Your screenshots should be in: $projectPath\screenshots\" -ForegroundColor Cyan
Write-Host "`nGood luck with your exam! 🚀`n" -ForegroundColor Green
