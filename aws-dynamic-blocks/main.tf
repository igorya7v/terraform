#--------------------------------------------------------
# Provision a simple VM Instance on GCP Platform.
#--------------------------------------------------------

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "webserver" {
  ami           = "ami-0915bcb5fa77e4892"
  instance_type = "t3.micro"

  # Attach the Security Group defined bellow.
  vpc_security_group_ids = [aws_security_group.webserver.id]

  # Load the Bootstrap Shell Script into the user_data area.
  user_data = file("user_data.sh")

  tags = {
    Name  = "WebServer Provisioned by Terraform"
    Owner = "Igor Yakubov"
  }
}

resource "aws_security_group" "webserver" {
  name        = "WebServer-SG"
  description = "Security Group for a Webserver"

  # Dynamic Block
  dynamic "ingress" {
    for_each = ["80", "8080", "443", "1000", "8443"]
    content {
      description = "Allow TCP Port"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # Dynamic Block
  dynamic "ingress" {
    for_each = ["1000", "2000", "3000"]
    content {
      description = "Allow UDP Port"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    description = "Allow SSH port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    description = "Allow ALL egress port"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "WebServer-SG Defined by Terraform"
    Owner = "Igor Yakubov"
  }
}
