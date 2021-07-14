#----------------------------------------------------------
# Lookup and Conditions
#----------------------------------------------------------
provider "aws" {
  region = "us-west-2"
}

data "aws_region" "current" {}


resource "aws_instance" "my_server" {
  ami = var.ami_id_per_region[data.aws_region.current.name]
  # Lookup in the var.server_size map where
  # Key: var.env
  # Default value (if key not found): var.server_size["my_default"]
  # Note - var.server_size[var.env] will fail,
  # as terraform will compain that the key=test is not found in the map.
  instance_type          = lookup(var.server_size, var.env, var.server_size["my_default"])
  vpc_security_group_ids = [aws_security_group.my_server.id]

  root_block_device {
    volume_size = 10
    encrypted   = (var.env == "prod") ? true : false
  }

  dynamic "ebs_block_device" {
    # for "prod", we provide a list of 1 item, 1 EBS device will be dynamicaly added.
    # for "non prod", we provide an empty list, no EBS device will be added.
    for_each = var.env == "prod" ? [true] : []
    content {
      device_name = "/dev/sdb"
      volume_size = 40
      encrypted   = true
    }
  }

  volume_tags = { Name = "Disk-${var.env}" }
  tags        = { Name = "Server-${var.env}" }
}


resource "aws_security_group" "my_server" {
  name = "My Server Security Group"

  dynamic "ingress" {
    for_each = lookup(var.allow_port, var.env, var.allow_port["rest"])
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name  = "My Server Dynamic SG"
    Owner = "Igor Yakubov"
  }
}
