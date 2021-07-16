output "vpc_id" {
  value = module.my_vpc_default.vpc_id
}

output "vpc_cidr" {
  value = module.my_vpc_default.vpc_cidr
}

output "public_subnet_ids" {
  value = module.my_vpc_default.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.my_vpc_default.private_subnet_ids
}
