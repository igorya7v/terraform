#--------------------------------------------------------
# Provision an Apache WebServer on AWS Platform.
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

  ingress {
    description = "Allow HTTP port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS port"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
