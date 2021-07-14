
# To select a specific file from command line:
# terraform apply -var-file="vars_staging.tfvars"

aws_region    = "us-east-1"
port_list     = ["80", "443", "22"]
instance_size = "t3.large"
key_pair      = "SomeKey"
password      = "12345"
