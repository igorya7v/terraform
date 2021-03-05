#-------------------------------------------------------------------------
# Provision 3 VMs with dependecies on AWS Platform.
# Outputs are used to print the Public IPs of the provisioned instances.
#-------------------------------------------------------------------------

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "server_web" {
  ami           = "ami-0915bcb5fa77e4892"
  instance_type = "t3.micro"

  # Attach the Security Group defined bellow.
  vpc_security_group_ids = [aws_security_group.general.id]

  depends_on = [
    aws_instance.server_db,
    aws_instance.server_app
  ]

  tags = {
    Name  = "Web Server Provisioned by Terraform"
    Owner = "Igor Yakubov"
  }
}

resource "aws_instance" "server_app" {
  ami           = "ami-0915bcb5fa77e4892"
  instance_type = "t3.micro"

  # Attach the Security Group defined bellow.
  vpc_security_group_ids = [aws_security_group.general.id]

  depends_on = [aws_instance.server_db]

  tags = {
    Name  = "App Server Provisioned by Terraform"
    Owner = "Igor Yakubov"
  }
}

resource "aws_instance" "server_db" {
  ami           = "ami-0915bcb5fa77e4892"
  instance_type = "t3.micro"

  # Attach the Security Group defined bellow.
  vpc_security_group_ids = [aws_security_group.general.id]

  tags = {
    Name  = "Database Server Provisioned by Terraform"
    Owner = "Igor Yakubov"
  }
}

resource "aws_security_group" "general" {
  name        = "General-SG"
  description = "General Security Group"

  dynamic "ingress" {
    for_each = ["80", "443", "22"]
    content {
      description = "Allow TCP Port"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    description = "Allow ALL egress port"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "General-SG Defined by Terraform"
    Owner = "Igor Yakubov"
  }
}

output "general_sg_id" {
  value = aws_security_group.general.id
}

output "server_web_public_ip" {
  value = [
    aws_instance.server_web.public_ip,
    aws_instance.server_app.public_ip,
    aws_instance.server_db.public_ip
  ]
}
