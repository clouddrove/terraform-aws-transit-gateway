provider "aws" {
  region = "eu-west-2"
}

##------------------------------------------------------------------------------
# VPC module call.
##------------------------------------------------------------------------------
module "vpc" {
  source  = "clouddrove/vpc/aws"
  version = "2.0.0"

  name        = "vpc"
  environment = "test"
  cidr_block  = "10.10.0.0/16"
}

##------------------------------------------------------------------------------
# Subnets module call.
##------------------------------------------------------------------------------
module "subnets" {
  source  = "clouddrove/subnet/aws"
  version = "2.0.0"

  name                = "subnet"
  environment         = "test"
  availability_zones  = ["eu-west-2a", "eu-west-2b"]
  vpc_id              = module.vpc.vpc_id
  type                = "public"
  igw_id              = module.vpc.igw_id
  nat_gateway_enabled = false
  cidr_block          = module.vpc.vpc_cidr_block
  ipv6_cidr_block     = module.vpc.ipv6_cidr_block
}

##------------------------------------------------------------------------------
# other-vpc module call.
##------------------------------------------------------------------------------
module "vpc-other" {
  source  = "clouddrove/vpc/aws"
  version = "2.0.0"

  name        = "vpc"
  environment = "test"

  cidr_block = "192.168.0.0/16"
}

##------------------------------------------------------------------------------
# other-subnets module call.
##------------------------------------------------------------------------------
module "subnets-other" {
  source  = "clouddrove/subnet/aws"
  version = "2.0.0"

  name                = "subnets"
  environment         = "test"
  availability_zones  = ["eu-west-2a", "eu-west-2b"]
  vpc_id              = module.vpc-other.vpc_id
  type                = "public"
  igw_id              = module.vpc-other.igw_id
  nat_gateway_enabled = false
  cidr_block          = module.vpc-other.vpc_cidr_block
  ipv6_cidr_block     = module.vpc-other.ipv6_cidr_block

}

##------------------------------------------------------------------------------
## transit-gateway module call.
##------------------------------------------------------------------------------
module "transit-gateway" {
  source                          = "./../../"
  name                            = "transit-gateway"
  environment                     = "test"
  tgw_create                      = true
  amazon_side_asn                 = 64512
  auto_accept_shared_attachments  = "enable"
  default_route_table_propagation = "enable"
  description                     = "This transit Gateway create for testing purpose"
  #TGW Share
  resource_share_enable                    = false
  resource_share_allow_external_principals = true
  resource_share_account_ids               = ["xxxxxxxxx"]
  # VPC Attachements
  vpc_attachement_create = false # Enable After once create the subnets
  vpc_id                 = module.vpc.vpc_id
  subnet_ids             = module.subnets.public_subnet_id
  destination_cidr_block = ["192.168.0.0/16", "172.16.0.0/12"]
}

#------------------------------------------------------------------------------
# vpc-attachement module call.
#------------------------------------------------------------------------------
module "vpc-attachement-2" {
  source      = "./../../"
  name        = "transit-gateway"
  environment = "test"
  # VPC Attachements
  vpc_id                          = module.vpc-other.vpc_id
  destination_cidr_block          = ["10.20.0.0/16"]
  vpc_attachement_create          = false # Enable After once create the subnets
  use_existing_transit_gateway_id = true
  transit_gateway_id              = module.transit-gateway.transit_gateway_id
  subnet_ids                      = module.subnets-other.public_subnet_id
}
