#----------------------------------------------------------
# Count Meta-Argument
#----------------------------------------------------------
provider "aws" {
  region = "us-west-2"
}


resource "aws_instance" "servers" {
  count         = 4
  ami           = "ami-0e472933a1395e172"
  instance_type = "t3.micro"
  tags = {
    Name  = "Server Number ${count.index + 1}"
    Owner = "Igor Yakubov"
  }
}

# DO NOT USE COUNT META-ARGUMENT TO CREATE users
# As it will be difficult to manage them in a list.
# For example in order to delete a user in the midle of the list,
# users after the deleted index will need to shifted.
resource "aws_iam_user" "user" {
  count = length(var.aws_users)
  name  = element(var.aws_users, count.index)
}

resource "aws_instance" "bastion_server" {
  count         = var.create_bastion == "YES" ? 1 : 0
  ami           = "ami-0e472933a1395e172"
  instance_type = "t3.micro"
  tags = {
    Name  = "Bastion Server"
    Owner = "Igor Yakubov"
  }
}
