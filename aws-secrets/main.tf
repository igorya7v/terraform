#-------------------------------------------------------------------------
# Provision RDS Instance.
# Use AWS Secrets Manager to store the password.
#-------------------------------------------------------------------------

provider "aws" {
  region = "us-east-1"
}

resource "aws_db_instance" "prod" {
  identifier           = "prod-mysql-rds"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  apply_immediately    = true
  username             = "admin"
  password             = data.aws_secretsmanager_secret_version.mysql_password.secret_string

  tags = {
    Name  = "Production MySQL Server"
    Owner = "Igor Yakubov"
  }
}

# Password Generator
resource "random_password" "main" {
  length = 20
  # special characters
  special          = true
  override_special = "#!()_"
}

# Secrets Manager to store the password
resource "aws_secretsmanager_secret" "mysql_password" {
  name                    = "/prod/mysql/password"
  description             = "Prod MySQL Password"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "mysql_password" {
  secret_id     = aws_secretsmanager_secret.mysql_password.id
  secret_string = random_password.main.result
}

# Retrieve password
data "aws_secretsmanager_secret_version" "mysql_password" {
  secret_id  = aws_secretsmanager_secret.mysql_password.id
  depends_on = [aws_secretsmanager_secret_version.mysql_password]
}

# Secrets Manager to store all MySQL params.
resource "aws_secretsmanager_secret" "mysql_all_params" {
  name                    = "/prod/mysql/all_params"
  description             = "Prod MySQL All Parameters"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "mysql_all_params" {
  secret_id = aws_secretsmanager_secret.mysql_all_params.id
  secret_string = jsonencode({
    mysql_endpoint = aws_db_instance.prod.endpoint
    mysql_port     = aws_db_instance.prod.endpoint
    mysql_username = aws_db_instance.prod.username
  })
}

# Retrieve all MySQL params
data "aws_secretsmanager_secret_version" "mysql_all_params" {
  secret_id  = aws_secretsmanager_secret.mysql_all_params.id
  depends_on = [aws_secretsmanager_secret_version.mysql_all_params]
}

output "mysql_endpoint" {
  value = aws_db_instance.prod.endpoint
}

output "mysql_username" {
  value = aws_db_instance.prod.username
}

output "mysql_password" {
  value = data.aws_secretsmanager_secret_version.mysql_password.secret_string
}

output "mysql_all_params" {
  value = jsondecode(data.aws_secretsmanager_secret_version.mysql_all_params.secret_string)
}
