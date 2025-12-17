# ============================================
# Ansible README
# DevOps Lab Exam - Node-Redis-Mongo Project
# ============================================

# Ansible Configuration Management

This directory contains Ansible configuration for automated deployment and management of the node-redis-mongo application.

## Directory Structure

```
ansible/
├── ansible.cfg           # Ansible configuration
├── hosts.ini             # Inventory file
├── playbook.yaml         # Main playbook
├── requirements.yaml     # Ansible Galaxy dependencies
├── README.md             # This file
├── group_vars/
│   ├── all.yaml          # Variables for all hosts
│   └── vault.yaml        # Encrypted secrets
└── templates/
    └── env.j2            # Environment file template
```

## Prerequisites

1. **Install Ansible** (Python 3.8+):
   ```bash
   pip install ansible ansible-lint
   ```

2. **Install required collections**:
   ```bash
   ansible-galaxy install -r requirements.yaml
   ```

3. **Configure SSH access** to target hosts

## Usage

### 1. Check Inventory
```bash
ansible-inventory --list -i hosts.ini
```

### 2. Test Connectivity
```bash
ansible all -m ping -i hosts.ini
```

### 3. Dry Run (Check Mode)
```bash
ansible-playbook playbook.yaml --check
```

### 4. Run Playbook
```bash
# All hosts
ansible-playbook playbook.yaml

# Specific group
ansible-playbook playbook.yaml --limit webservers

# With verbose output
ansible-playbook playbook.yaml -vvv
```

### 5. Using Vault for Secrets
```bash
# Encrypt vault file
ansible-vault encrypt group_vars/vault.yaml

# Run with vault password
ansible-playbook playbook.yaml --ask-vault-pass

# Or use password file
ansible-playbook playbook.yaml --vault-password-file ~/.vault_pass
```

## Playbook Tasks

The main playbook performs:

1. **System Preparation**
   - Update package cache
   - Install required packages
   - Set timezone

2. **Docker Installation**
   - Install Docker and Docker Compose
   - Start Docker service
   - Configure user permissions

3. **Node.js Installation**
   - Install Node.js 18.x
   - Install PM2 globally

4. **Application Deployment**
   - Create application user/group
   - Clone Git repository
   - Install npm dependencies
   - Configure environment
   - Start with Docker Compose

5. **Monitoring Setup**
   - Install Node Exporter
   - Configure systemd service

## Variables

Key variables in `group_vars/all.yaml`:

| Variable | Default | Description |
|----------|---------|-------------|
| `app_name` | node-redis-mongo | Application name |
| `app_port` | 5000 | Application port |
| `node_version` | 18 | Node.js version |
| `mongodb_port` | 27017 | MongoDB port |
| `redis_port` | 6379 | Redis port |

## Host Groups

| Group | Description |
|-------|-------------|
| `webservers` | Application servers |
| `dbservers` | Database servers |
| `cacheservers` | Redis cache servers |
| `monitoring` | Prometheus/Grafana |
| `local` | Local development |

## Security Notes

- Store sensitive data in `vault.yaml`
- Always encrypt vault files in production
- Use SSH key authentication
- Limit sudo privileges

## Troubleshooting

### Connection Issues
```bash
ansible all -m ping -vvvv
```

### Check Facts
```bash
ansible hostname -m setup
```

### Syntax Check
```bash
ansible-playbook playbook.yaml --syntax-check
```

### Lint Playbook
```bash
ansible-lint playbook.yaml
```

---
**Author:** junaidrao47  
**Project:** DevOps Lab Exam - node-redis-mongo
