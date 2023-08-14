provider "aws" {
  region = "eu-west-1"
}

##------------------------------------------------------------------------------
# VPC module call.
##------------------------------------------------------------------------------
module "vpc" {
  source      = "clouddrove/vpc/aws"
  version     = "2.0.0"
  name        = "vpc"
  environment = "test"
  cidr_block  = "172.16.0.0/16"
}

##------------------------------------------------------------------------------
# Subnet module call.
##------------------------------------------------------------------------------
module "subnets" {
  source  = "clouddrove/subnet/aws"
  version = "1.3.0"

  name                = "subnets"
  environment         = "test"
  availability_zones  = ["eu-west-1a", "eu-west-1b"]
  vpc_id              = module.vpc.vpc_id
  type                = "public"
  igw_id              = module.vpc.igw_id
  nat_gateway_enabled = false
  cidr_block          = module.vpc.vpc_cidr_block
  ipv6_cidr_block     = module.vpc.ipv6_cidr_block

}

##------------------------------------------------------------------------------
# transit-gateway module call.
##------------------------------------------------------------------------------
module "transit-gateway" {
  source      = "./../../"
  name        = "transit-gateway"
  environment = "test"

  #Transit gateway invitation accepter
  aws_ram_resource_share_accepter = false
  resource_share_arn              = "arn:aws:ram:eu-west-1:XXXXXXXXXXX:resource-share/XXXXXXXXXXXXXXXXXXXXXXXXXX"
  subnet_ids                      = module.subnets.private_subnet_id

  # VPC Attachements
  vpc_attachement_create          = false # Enable After once create the subnets
  vpc_id                          = module.vpc.vpc_id
  use_existing_transit_gateway_id = true
  transit_gateway_id              = "tgw-XXXXXXXXXXX"
  destination_cidr_block          = ["10.0.0.0/8", "172.16.0.0/12"]
}
