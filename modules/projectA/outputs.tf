# Default VPC ------------------------------------------------------------------

# commenting out, as there is a limited number of Elastic IPs in AWS free tier

# output "vpc_default_id" {
#   value = module.vpc_default.vpc_id
# }
#
# output "vpc_default_cidr" {
#   value = module.vpc_default.vpc_cidr
# }
#
# output "vpc_default_public_subnet_ids" {
#   value = module.vpc_default.public_subnet_ids
# }
#
# output "vpc_default_private_subnet_ids" {
#   value = module.vpc_default.private_subnet_ids
# }


# Staging VPC ------------------------------------------------------------------
output "vpc_staging_id" {
  value = module.vpc_staging.vpc_id
}

output "vpc_staging_cidr" {
  value = module.vpc_staging.vpc_cidr
}

output "vpc_staging_public_subnet_ids" {
  value = module.vpc_staging.public_subnet_ids
}

output "vpc_staging_private_subnet_ids" {
  value = module.vpc_staging.private_subnet_ids
}


# Production VPC ---------------------------------------------------------------
output "vpc_prod_id" {
  value = module.vpc_prod.vpc_id
}

output "vpc_prod_cidr" {
  value = module.vpc_prod.vpc_cidr
}

output "vpc_prod_public_subnet_ids" {
  value = module.vpc_prod.public_subnet_ids
}

output "vpc_prod_private_subnet_ids" {
  value = module.vpc_prod.private_subnet_ids
}
