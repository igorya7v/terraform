variable "aws_users" {
  description = "List of IAM Users to create"
  default = [
    "igor@email.com",
    "krisa@email.com",
    "kevin@email.com",
    "jessy@email.com",
    "robby@email.com",
    "katie@email.com",
    "laura@email.com",
    "josef@email.com"
  ]
}

variable "create_bastion" {
  description = "Provision Bastion Server YES/NO"
  default     = "NO"
}
