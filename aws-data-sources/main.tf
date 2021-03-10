#------------------------------------------------------------
# Fetch information about AWS Components using data sources.
#------------------------------------------------------------

provider "aws" {
  region = "us-east-1"
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available_zones" {}
data "aws_vpcs" "vpcs" {}

# Fetch VPC info by Tag.
data "aws_vpc" "staging" {
  tags = {
    Name = "Staging"
  }
}

# Provision the Subnet-1 using the fetched vpc_id and availability zone.
resource "aws_subnet" "subnet-1" {
  vpc_id            = data.aws_vpc.staging.id
  availability_zone = data.aws_availability_zones.available_zones.names[0]
  cidr_block        = "10.1.1.0/24"

  tags = {
    Name = "Subnet-1"
    Info = "AZ: ${data.aws_availability_zones.available_zones.names[0]}, Region: ${data.aws_region.current.description}"
  }
}

# Provision the Subnet-2 using the fetched vpc_id and availability zone.
resource "aws_subnet" "subnet-2" {
  vpc_id            = data.aws_vpc.staging.id
  availability_zone = data.aws_availability_zones.available_zones.names[1]
  cidr_block        = "10.1.2.0/24"

  tags = {
    Name = "Subnet-2"
    Info = "AZ: ${data.aws_availability_zones.available_zones.names[0]}, Region: ${data.aws_region.current.description}"
  }
}

output "region_name" {
  value = data.aws_region.current.name
}

output "region_description" {
  value = data.aws_region.current.description
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "availability_zones" {
  value = data.aws_availability_zones.available_zones.names
}

output "available_vpcs" {
  value = data.aws_vpcs.vpcs.ids
}
