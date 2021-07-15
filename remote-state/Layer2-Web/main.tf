#----------------------------------------------------------
# Set S3 Backend for Terraform Remote State
# Get Outputs from another Terraform Remote State
# Deploy Web Layer
#----------------------------------------------------------
provider "aws" {
  region = "us-east-1"
}

// Store Remote State
terraform {
  backend "s3" {
    // Bucket where to SAVE Terraform State
    bucket = "terraform-remote-state-igor-1"
    // Object name in the bucket to SAVE Terraform State
    key = "dev/webserver/terraform.tfstate"
    // Region where bucket created
    region = "us-east-1"
  }
}

// Use Outputs of Layer1-Network from Remote State
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    // Bucket from where to GET Terraform State
    bucket = "terraform-remote-state-igor-1"
    // Object name in the bucket to GET Terraform State
    key = "dev/network/terraform.tfstate"
    // Region where bucket created
    region = "us-east-1"
  }
}


#-------------------------------------------------------------------------
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.webserver.id]
  subnet_id              = data.terraform_remote_state.vpc.outputs.public_subnet_ids[0]

  # Load the Bootstrap Shell Script into the user_data area.
  user_data = file("user_data.sh")

  tags = {
    Name  = "${var.env}-WebServer"
    Owner = "Igor Yakubov"
  }
}

resource "aws_security_group" "webserver" {
  name   = "WebServer Security Group"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH from within the VPC only
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "${var.env}-web-server-sg"
    Owner = "Igor Yakubov"
  }
}
