provider "aws" {
  region = var.aws_region
}

data "aws_region" "current" {}
data "aws_availability_zones" "azs" {}

# Local Variables
locals {
  Region_Info = "AWS Region: ${data.aws_region.current.description}, Available AZs: ${length(data.aws_availability_zones.azs.names)}"
}

# Elastic IP
resource "aws_eip" "webserver" {
  instance = aws_instance.webserver.id
  tags     = merge(var.tags, { Name = "${var.tags["Environment"]}-Elastic IP (EIP) for Demo WebServer" })
}

resource "aws_instance" "webserver" {
  ami           = "ami-0dc2d3e4c0f9ebd18"
  instance_type = var.instance_size

  # Attach the Security Group defined bellow.
  vpc_security_group_ids = [aws_security_group.webserver.id]

  key_name = var.key_pair

  # Load the Bootstrap Shell Script into the user_data area.
  user_data = file("user_data.sh")

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.tags, {
    Name        = "${var.tags["Environment"]}-WebServer Provisioned by Terraform"
    Region_Info = local.Region_Info
  })
}

resource "aws_security_group" "webserver" {
  name        = "WebServer-SG"
  description = "Security Group for a Webserver"

  dynamic "ingress" {
    for_each = var.port_list
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

  tags = merge(var.tags, { Name = "${var.tags["Environment"]}-WebServer-SG Defined by Terraform" })
}
