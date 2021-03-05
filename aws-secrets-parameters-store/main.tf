#-------------------------------------------------------------------------
# Provision RDS Instance.
# Use Parameter Store to store the password.
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
  password             = data.aws_ssm_parameter.mysql_password.value

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

# Sysstem Manager Parameter Store (SSM)
resource "aws_ssm_parameter" "rds_password" {
  name        = "/prod/prod-mysql-rds/password"
  description = "Master Password for MySQL Database"
  type        = "SecureString"
  value       = random_password.main.result
}

# Retrieve password
data "aws_ssm_parameter" "mysql_password" {
  name       = "/prod/prod-mysql-rds/password"
  depends_on = [aws_ssm_parameter.rds_password]
}

output "mysql_endpoint" {
  value = aws_db_instance.prod.endpoint
}

output "mysql_username" {
  value = aws_db_instance.prod.username
}

output "mysql_password" {
  value = data.aws_ssm_parameter.mysql_password.value
  # It's still visible in the tfstate file!
  sensitive = true
}
