#--------------------------------------------------------
# Provision a VM Instance with Elastic IP on AWS Platform.
#--------------------------------------------------------

provider "aws" {
  region = "us-east-1"
}

# Elastic IP
resource "aws_eip" "webserver" {
  instance = aws_instance.webserver.id
  tags = {
    Name  = "Elastic IP (EIP) for Demo WebServer"
    Owner = "Igor Yakubov"
  }
}

resource "aws_instance" "webserver" {
  ami           = "ami-0915bcb5fa77e4892"
  instance_type = "t3.micro"

  # Attach the Security Group defined bellow.
  vpc_security_group_ids = [aws_security_group.webserver.id]

  # Load the Bootstrap Shell Script into the user_data area.
  user_data = file("user_data.sh")

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name  = "WebServer Provisioned by Terraform"
    Owner = "Igor Yakubov"
  }
}

resource "aws_security_group" "webserver" {
  name        = "WebServer-SG"
  description = "Security Group for a Webserver"

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
    Name  = "WebServer-SG Defined by Terraform"
    Owner = "Igor Yakubov"
  }
}
