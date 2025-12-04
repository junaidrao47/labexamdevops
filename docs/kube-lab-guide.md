# Kubernetes Beginner Lab Challenge Guide

This guide walks through the entire lab scenario step by step, from building a simple Dockerized application to deploying it on a local Kubernetes cluster, wiring up GitHub CI, troubleshooting common issues, and completing the optional playground challenges.

> **Scenario**: You are migrating a small Docker Compose-style application (e.g., "Hello from Kubernetes" Node.js app) into Kubernetes. The lab simulates a DevOps onboarding task using Docker Desktop or Minikube plus GitHub.

---

## Prerequisites

- Docker Desktop **with** Kubernetes enabled **or** Minikube installed (`minikube v1.30+`).
- kubectl CLI (`kubectl version --client`).
- GitHub account and Git installed locally.
- Basic application source code (Node.js, Python Flask, Go, or static site).

> Replace `kube-lab-app` with your actual app name if different.

---

## Task 1 — Prepare the Application Repository

1. Clone the starter repository (or create a new one and add your app files):
   ```bash
   git clone https://github.com/<you>/kube-lab-app.git
   cd kube-lab-app
   ```
2. Ensure the root contains:
   ```text
   kube-lab-app/
   ├── app.js (or main.py)
   ├── package.json (if Node)
   ├── Dockerfile
   └── README.md
   ```
3. Verify `.gitignore` ignores node_modules/venv/dist as appropriate for your stack.

---

## Task 2 — Build and Test the Docker Image Locally

1. Build the image:
   ```bash
   docker build -t kube-lab-app:v1 .
   ```
2. Run the container locally:
   ```bash
   docker run --rm -p 8080:8080 kube-lab-app:v1
   ```
3. Test in another terminal:
   ```bash
   curl http://localhost:8080
   ```
   Expected output: `Hello from Kubernetes!`
4. Stop the container (Ctrl+C or `docker stop <container-id>`).

> Troubleshooting: If the port is already in use, change to `-p 8081:8080` and test on `localhost:8081`.

---

## Task 3 — Push Code to GitHub

1. Initialize Git (if not already):
   ```bash
   git init
   git add .
   git commit -m "feat: initial kube lab app"
   ```
2. Create a GitHub repo `kube-lab-app`.
3. Add remote & push:
   ```bash
   git remote add origin https://github.com/<you>/kube-lab-app.git
   git branch -M main
   git push -u origin main
   ```
4. Confirm the repo now contains app source, Dockerfile, and an empty `k8s/` directory (created next).

---

## Task 4 — Create Kubernetes Manifests

Inside a new folder `k8s/` add:

### `k8s/deployment.yaml`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kube-lab-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: kube-lab
  template:
    metadata:
      labels:
        app: kube-lab
    spec:
      containers:
        - name: kube-lab-container
          image: kube-lab-app:v1
          ports:
            - containerPort: 8080
```

### `k8s/service.yaml`
```yaml
apiVersion: v1
kind: Service
metadata:
  name: kube-lab-service
spec:
  type: NodePort
  selector:
    app: kube-lab
  ports:
    - port: 8080
      targetPort: 8080
      nodePort: 30080   # Any free port in 30000-32767
```

> Commit these manifests: `git add k8s/*.yaml && git commit -m "feat: add k8s manifests"`

---

## Task 5 — Enable Local Kubernetes Cluster

**Option A: Docker Desktop**
1. Settings → Kubernetes → Enable Kubernetes → Apply & Restart.
2. Wait until status shows `Running`.

**Option B: Minikube**
```bash
minikube start
```

Validate cluster access:
```bash
kubectl cluster-info
kubectl get nodes
```

---

## Task 6 — Load Local Docker Image into Kubernetes

- **Docker Desktop** shares the Docker engine with Kubernetes. No extra steps.
- **Minikube** uses its own Docker daemon:
  ```bash
  minikube image load kube-lab-app:v1
  ```
  Confirm the image exists inside Minikube:
  ```bash
  minikube ssh -- docker images | grep kube-lab-app
  ```

---

## Task 7 — Apply the Kubernetes Manifests

1. Apply all manifests:
   ```bash
   kubectl apply -f k8s/
   ```
2. Verify Pods:
   ```bash
   kubectl get pods -l app=kube-lab
   ```
   Expected: 2 Pods in `Running` state.
3. Verify Service:
   ```bash
   kubectl get svc kube-lab-service
   ```
   Expected: `TYPE NodePort` with `PORT(S) 8080:30080/TCP`.

---

## Task 8 — Access the Application

- **Docker Desktop**: Access `http://localhost:30080`.
- **Minikube**:
  ```bash
  minikube service kube-lab-service
  ```
  This launches the default browser to the service URL.

Expected page: `Hello from Kubernetes!`

---

## Task 9 — Break and Fix the Deployment

1. Introduce an error (e.g., mismatch labels) in `deployment.yaml`:
   ```yaml
   template:
     metadata:
       labels:
         app: kube-lab-broken   # wrong label
   ```
2. Apply:
   ```bash
   kubectl apply -f k8s/deployment.yaml
   ```
3. Observe the issue:
   ```bash
   kubectl get pods
   kubectl describe svc kube-lab-service
   ```
   The Service shows `Endpoints: <none>` because selectors no longer match.
4. Troubleshoot using logs/describes (for other error types):
   ```bash
   kubectl logs <pod>
   kubectl describe pod <pod>
   ```
5. Fix the manifest (restore label), reapply:
   ```bash
   kubectl apply -f k8s/
   ```
6. Confirm Pods and Service are healthy again.

---

## Task 10 — Add Simple GitHub Actions Workflow

Create `.github/workflows/ci.yml`:
```yaml
name: CI Test

on: [push]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 18
      - name: Install dependencies
        run: npm install
      - name: Run tests
        run: npm test
```

> Adjust for Python/Go as needed. Push to GitHub and verify the workflow succeeds in the Actions tab.

---

# Kubernetes Playground Challenge Pack

Each challenge builds additional intuition. Perform them in your existing cluster.

## Challenge 1 — Scale Your Application
```bash
kubectl scale deployment kube-lab-deployment --replicas=5
kubectl get pods
kubectl scale deployment kube-lab-deployment --replicas=1
```
Observe Pods being created/destroyed automatically.

## Challenge 2 — Rolling Updates & Rollbacks
1. Update application text to "Hello v2!" and rebuild:
   ```bash
   docker build -t kube-lab-app:v2 .
   # Minikube only: minikube image load kube-lab-app:v2
   ```
2. Update Deployment image:
   ```bash
   kubectl set image deployment/kube-lab-deployment kube-lab-container=kube-lab-app:v2
   kubectl rollout status deployment/kube-lab-deployment
   ```
3. Roll back:
   ```bash
   kubectl rollout undo deployment kube-lab-deployment
   ```

## Challenge 3 — Use a LoadBalancer Service (Minikube)
```bash
kubectl edit svc kube-lab-service
# change type: NodePort -> LoadBalancer
minikube tunnel
kubectl get svc kube-lab-service
```
Observe the external IP assigned while the tunnel is running.

## Challenge 4 — Add Resource Requests/Limits
Edit `deployment.yaml` container spec:
```yaml
resources:
  requests:
    cpu: "100m"
    memory: "128Mi"
  limits:
    cpu: "200m"
    memory: "256Mi"
```
Apply and inspect:
```bash
kubectl apply -f k8s/deployment.yaml
kubectl describe pod <pod>
```

## Challenge 5 — ConfigMap + Environment Variable
```bash
kubectl create configmap app-config --from-literal=APP_ENV=dev
```
Add to Deployment container spec:
```yaml
env:
  - name: APP_ENV
    valueFrom:
      configMapKeyRef:
        name: app-config
        key: APP_ENV
```
Apply and verify:
```bash
kubectl exec -it <pod> -- env | grep APP_ENV
```

## Challenge 6 — Liveness & Readiness Probes
```yaml
livenessProbe:
  httpGet:
    path: /
    port: 8080
  initialDelaySeconds: 3
  periodSeconds: 5
readinessProbe:
  httpGet:
    path: /
    port: 8080
  initialDelaySeconds: 3
  periodSeconds: 5
```
Apply and inspect:
```bash
kubectl apply -f k8s/deployment.yaml
kubectl describe pod <pod>
```

## Challenge 7 — Self-Healing
```bash
kubectl delete pod <one-pod-name>
kubectl get pods
```
Observe Kubernetes automatically creating a replacement Pod.

## Challenge 8 — Pause and Resume Deployment
```bash
kubectl rollout pause deployment kube-lab-deployment
# make manifest changes here
kubectl rollout resume deployment kube-lab-deployment
```
During pause, new changes are queued but not rolled out until resume.

## Challenge 9 — Inspect Cluster Resources
```bash
kubectl get nodes
kubectl describe node <node-name>
kubectl top nodes
kubectl top pods
```
Requires Metrics Server for `kubectl top`.

## Challenge 10 — Delete and Recreate
```bash
kubectl delete -f k8s/
kubectl apply -f k8s/
```
Practice full teardown and redeploy.

---

## Verification & Next Steps

1. **GitHub CI**: Ensure the workflow passes on every push.
2. **Kubernetes**: `kubectl get all` shows healthy resources.
3. **Documentation**: Update README with steps, screenshots, or outputs.
4. **Further Practice**:
   - Integrate Ingress + TLS locally (e.g., nginx-ingress + mkcert).
   - Add automated tests in CI (lint + unit tests).
   - Experiment with Helm charts for templating.

Good luck, and enjoy the lab! :rocket:
