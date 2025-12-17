# ============================================
# RDS PostgreSQL Configuration
# Managed database for persistence
# ============================================

# ============================================
# DB Subnet Group
# ============================================
resource "aws_db_subnet_group" "main" {
  count = var.create_rds ? 1 : 0

  name        = "${var.project_name}-db-subnet-group-${var.environment}"
  description = "Database subnet group for ${var.project_name}"
  subnet_ids  = aws_subnet.private[*].id

  tags = {
    Name = "${var.project_name}-db-subnet-group-${var.environment}"
  }
}

# ============================================
# Random Password for RDS (if not provided)
# ============================================
resource "random_password" "db_password" {
  count = var.create_rds && var.db_password == "" ? 1 : 0

  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

locals {
  db_password = var.db_password != "" ? var.db_password : (var.create_rds ? random_password.db_password[0].result : "")
}

# ============================================
# RDS PostgreSQL Instance
# ============================================
resource "aws_db_instance" "main" {
  count = var.create_rds ? 1 : 0

  identifier = "${var.project_name}-db-${var.environment}"

  # Engine configuration
  engine               = "postgres"
  engine_version       = "15.4"
  instance_class       = var.db_instance_class
  allocated_storage    = var.db_allocated_storage
  max_allocated_storage = var.db_allocated_storage * 2
  storage_type         = "gp3"
  storage_encrypted    = true

  # Database configuration
  db_name  = var.db_name
  username = var.db_username
  password = local.db_password
  port     = 5432

  # Network configuration
  db_subnet_group_name   = aws_db_subnet_group.main[0].name
  vpc_security_group_ids = [aws_security_group.database.id]
  publicly_accessible    = false
  multi_az               = var.environment == "prod" ? true : false

  # Backup configuration
  backup_retention_period = var.environment == "prod" ? 7 : 1
  backup_window           = "03:00-04:00"
  maintenance_window      = "Mon:04:00-Mon:05:00"

  # Performance and monitoring
  performance_insights_enabled = var.environment == "prod" ? true : false
  monitoring_interval          = 0

  # Deletion protection (enable in production)
  deletion_protection = var.environment == "prod" ? true : false
  skip_final_snapshot = var.environment == "prod" ? false : true
  final_snapshot_identifier = var.environment == "prod" ? "${var.project_name}-db-final-snapshot-${var.environment}" : null

  # Parameter group
  parameter_group_name = aws_db_parameter_group.main[0].name

  tags = {
    Name = "${var.project_name}-db-${var.environment}"
  }
}

# ============================================
# RDS Parameter Group
# ============================================
resource "aws_db_parameter_group" "main" {
  count = var.create_rds ? 1 : 0

  name        = "${var.project_name}-db-params-${var.environment}"
  family      = "postgres15"
  description = "Parameter group for ${var.project_name}"

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "log_disconnections"
    value = "1"
  }

  tags = {
    Name = "${var.project_name}-db-params-${var.environment}"
  }
}

# ============================================
# Store DB Credentials in Secrets Manager
# ============================================
resource "aws_secretsmanager_secret" "db_credentials" {
  count = var.create_rds ? 1 : 0

  name        = "${var.project_name}/db-credentials/${var.environment}"
  description = "Database credentials for ${var.project_name}"

  tags = {
    Name = "${var.project_name}-db-credentials-${var.environment}"
  }
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  count = var.create_rds ? 1 : 0

  secret_id = aws_secretsmanager_secret.db_credentials[0].id
  secret_string = jsonencode({
    username = var.db_username
    password = local.db_password
    engine   = "postgres"
    host     = aws_db_instance.main[0].endpoint
    port     = 5432
    dbname   = var.db_name
  })
}
