# Provision AWS Network Layer for Staging and Production environments. 

Provision AWS Network Layer for Staging and Production environments using the Terraform Modules (see modules/aws_network/ folder).

## Components
### Staging
  * VPC
  * Internet Gateway
  * Public Subnets
  * NAT Gateways 

### Production
  * VPC
  * Internet Gateway
  * Public Subnets
  * Private Subnets
  * NAT Gateways in Public Subnets to give one way Internet access to Private Subnets 

## Diagram - Staging
![Diagram](https://github.com/igorya7v/terraform/blob/main/modules/projectA/VPC%20-%20Staging.png)
https://github.com/igorya7v/terraform/blob/main/modules/projectA/diagrams/AWS%20Network%20Layer%20-%20Staging.png

## Diagram - Production
![Diagram](https://github.com/igorya7v/terraform/blob/main/modules/projectA/VPC%20-%20Staging.png)
https://github.com/igorya7v/terraform/blob/main/modules/projectA/diagrams/AWS%20Network%20Layer%20-%20Production.png
