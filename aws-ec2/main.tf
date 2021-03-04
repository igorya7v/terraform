provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "some_server" {
  ami           = "ami-042e8287309f5df03"
  instance_type = "t3.micro"
  key_name      = "ec2-key-1"

  tags = {
    Name    = "some-ubuntu-server"
    Owner   = "Igor Yakubov"
    Project = "Some Project"
  }
}

resource "aws_instance" "some_server-2" {
  ami           = "ami-042e8287309f5df03"
  instance_type = "t3.micro"
  key_name      = "ec2-key-1"

  tags = {
    Name = "some-ubuntu-server-2"
  }
}
