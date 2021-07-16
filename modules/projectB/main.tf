#-------------------------------------------------------------------------------
# Provision VPC and Web Servers in Public Subnets using Modules
#-------------------------------------------------------------------------------
provider "aws" {
  region = "us-east-1"
}

module "vpc_prod" {
  source               = "../modules/aws_network"
  env                  = "prod"
  vpc_cidr             = "10.200.0.0/16"
  public_subnet_cidrs  = ["10.200.1.0/24", "10.200.2.0/24"]
  private_subnet_cidrs = ["10.200.11.0/24", "10.200.22.0/24"]
  tags = {
    Owner   = "Igor Yakubov"
    Project = "Project B"
  }
}

module "server_standalone" {
  source    = "../modules/aws_testserver"
  name      = "DEMO_SERVER"
  subnet_id = module.vpc_prod.public_subnet_ids[1]
}

module "servers_loop_count" {
  source    = "../modules/aws_testserver"
  count     = length(module.vpc_prod.public_subnet_ids)
  name      = "DEMO_SERVER"
  subnet_id = module.vpc_prod.public_subnet_ids[count.index]
}
