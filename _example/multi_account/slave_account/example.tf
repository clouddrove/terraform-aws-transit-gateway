provider "aws" {
  region = "eu-west-2"
}

locals {
  name        = "app_1"
  environment = "test"
}

##------------------------------------------------------------------------------
## VPC module call.
##------------------------------------------------------------------------------
module "vpc" {
  source      = "clouddrove/vpc/aws"
  version     = "2.0.0"
  name        = local.name
  environment = local.environment
  cidr_block  = "10.11.0.0/16"
}

##------------------------------------------------------------------------------
## Subnet module call.
##------------------------------------------------------------------------------
#tfsec:ignore:aws-ec2-no-excessive-port-access # Ingnored because these are basic examples, it can be changed via varibales as per requirement.
#tfsec:ignore:aws-ec2-no-public-ingress-acl # Ingnored because these are basic examples, it can be changed via varibales as per requirement.
module "subnets" {
  source              = "clouddrove/subnet/aws"
  version             = "2.0.0"
  name                = local.name
  environment         = local.environment
  availability_zones  = ["eu-west-2a", "eu-west-2b"]
  vpc_id              = module.vpc.vpc_id
  type                = "private"
  igw_id              = module.vpc.igw_id
  nat_gateway_enabled = false
  cidr_block          = module.vpc.vpc_cidr_block
  ipv6_cidr_block     = module.vpc.ipv6_cidr_block
}

##------------------------------------------------------------------------------
## Transit-gateway module call for diff account.
## Transit gateway configuration for slave account. This account will share/use a central transit gateway hosted in main account.
##------------------------------------------------------------------------------
module "transit_gateway_peer" {
  depends_on  = [module.vpc, module.subnets]
  source      = "./../../../"
  name        = local.name
  environment = local.environment
  tgw_create  = false
  #TGW Share
  aws_ram_resource_share_accepter = true
  resource_share_arn              = "arn:aws:ram:eu-west-1:xxxxxxxx:resource-share/40b2b19b-6de6-478a-849b-xxxxxxxx"
  # VPC Attachements
  transit_gateway_id = "tgw-02c00xxxxxxx"
  vpc_attachments = {
    vpc1 = {
      vpc_id                                          = module.vpc.vpc_id
      subnet_ids                                      = module.subnets.private_subnet_id
      transit_gateway_default_route_table_association = true
      transit_gateway_default_route_table_propagation = true
      vpc_route_table_ids                             = module.subnets.private_route_tables_id
      destination_cidr                                = ["10.10.0.0/16"]
    }
  }
}
