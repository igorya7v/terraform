# Variable can include 5 different arguments,
# However, non of them is mandatory
variable "aws_region" {
  description = "Region where the AWS Resources are provisioned"
  # String, number, boolean, list, map
  type    = string
  default = "us-east-1"
}

variable "port_list" {
  description = "List of open ports"
  type        = list(any)
  default     = ["80", "443", "22"]
}

variable "instance_size" {
  description = "EC2 Instance size"
  default     = "t3.micro"
}

variable "key_pair" {
  description = "SSH Key pair name"
  type        = string
  default     = "SomeKey"
  sensitive   = true
}

variable "password" {
  description = "Please enter a password (5 chars length)"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.password) == 5
    error_message = "Password must be 5 chars length!"
  }
}

variable "tags" {
  description = "Tags to apply to AWS resource"
  type        = map(any)
  default = {
    Owner       = "Igor Yakubov"
    Environment = "Prod"
    Project     = "My Project"
  }
}
