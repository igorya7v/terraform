#----------------------------------------------------------
# Provision Simple Web Server in specific Subnet
#----------------------------------------------------------

data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# To get the VPC ID
data "aws_subnet" "web" {
  id = var.subnet_id
}

resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.webserver.id]
  subnet_id              = var.subnet_id
  tags = {
    Name  = "${var.name}-WebServer-${var.subnet_id}"
    Owner = "Igor Yakubov"
  }
}

resource "aws_security_group" "webserver" {
  name_prefix = "${var.name}-WebServer SG-"
  vpc_id      = data.aws_subnet.web.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "${var.name}-web-server-sg"
    Owner = "Igor Yakubov"
  }
}
