#----------------------------------------------------------
# Deploy in Multiply AWS Regions
#----------------------------------------------------------
provider "aws" {
  region = "us-west-1"
}

provider "aws" {
  region = "ca-central-1"
  alias  = "CANADA"
}

provider "aws" {
  region = "ap-northeast-1"
  alias  = "ASIA"
}

#==================================================================

data "aws_ami" "defaut_latest_ubuntu20" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

data "aws_ami" "canada_latest_ubuntu20" {
  provider    = aws.CANADA
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

data "aws_ami" "asia_latest_ubuntu20" {
  provider    = aws.ASIA
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

#============================================================================
resource "aws_instance" "default_server" {
  instance_type = "t3.micro"
  ami           = data.aws_ami.defaut_latest_ubuntu20.id
  tags = {
    Name = "Default Server"
  }
}

resource "aws_instance" "canada_server" {
  provider      = aws.CANADA
  instance_type = "t3.micro"
  ami           = data.aws_ami.canada_latest_ubuntu20.id
  tags = {
    Name = "Europe Server"
  }
}

resource "aws_instance" "asia_server" {
  provider      = aws.ASIA
  instance_type = "t3.micro"
  ami           = data.aws_ami.asia_latest_ubuntu20.id
  tags = {
    Name = "Asia Server"
  }
}
