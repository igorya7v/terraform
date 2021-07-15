#----------------------------------------------------------
# Set S3 Backend for Terraform Remote State
# Deploy Network Layer
#----------------------------------------------------------
provider "aws" {
  region = "us-east-1"
}

data "aws_availability_zones" "available" {}

terraform {
  backend "s3" {
    // Bucket where to SAVE Terraform State
    bucket = "terraform-remote-state-igor-1"
    // Object name in the bucket to SAVE Terraform State
    key = "dev/network/terraform.tfstate"
    // Region where bucket is created
    region = "us-east-1"
  }
}


resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name  = "${var.env}-vpc"
    Owner = "Igor Yakubov"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name  = "${var.env}-igw"
    Owner = "Igor Yakubov"
  }
}


resource "aws_subnet" "public_subnets" {
  count  = length(var.public_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  # Element retrieves a single element from a list.
  # Produces an error is used with an empt list.
  # I use it here for learning purposes.
  # Terraform documentation suggests to use
  # the build-in syntax list[index] in most of the cases.
  # https://www.terraform.io/docs/language/functions/element.html
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  # (Optional) Specify true to indicate that instances launched into the subnet
  # should be assigned a public IP address.
  # Default is false.
  map_public_ip_on_launch = true
  tags = {
    Name  = "${var.env}-public-${count.index + 1}"
    Owner = "Igor Yakubov"
  }
}


resource "aws_route_table" "public_subnets" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name  = "${var.env}-route-public-subnets"
    Owner = "Igor Yakubov"
  }
}

# Attach the IP Gateway to public subnets
resource "aws_route_table_association" "public_routes" {
  count          = length(aws_subnet.public_subnets[*].id)
  route_table_id = aws_route_table.public_subnets.id
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
}
