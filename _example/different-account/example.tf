provider "aws" {
  region = "eu-west-2"
}

provider "aws" {
  alias = "test"
  assume_role {
    role_arn = ""
  }
  region = "eu-west-2"
}
locals {
  name              = "app"
  environment       = "test"
  other_name        = "app_1"
  other_environment = "test_1"
}

##------------------------------------------------------------------------------
## VPC module call.
##------------------------------------------------------------------------------
module "vpc" {
  source      = "clouddrove/vpc/aws"
  version     = "2.0.0"
  name        = local.name
  environment = local.environment
  cidr_block  = "10.10.0.0/16"
}

##------------------------------------------------------------------------------
## Subnet module call.
##------------------------------------------------------------------------------
module "subnets" {
  source              = "clouddrove/subnet/aws"
  version             = "2.0.0"
  name                = local.name
  environment         = local.environment
  availability_zones  = ["eu-west-2a", "eu-west-2b"]
  vpc_id              = module.vpc.vpc_id
  type                = "public"
  igw_id              = module.vpc.igw_id
  nat_gateway_enabled = false
  cidr_block          = module.vpc.vpc_cidr_block
  ipv6_cidr_block     = module.vpc.ipv6_cidr_block
}

##------------------------------------------------------------------------------
## Other-vpc module call.
##------------------------------------------------------------------------------
module "vpc_other" {
  source      = "clouddrove/vpc/aws"
  version     = "2.0.0"
  name        = local.other_name
  environment = local.other_environment
  cidr_block  = "192.168.0.0/16"
}

##------------------------------------------------------------------------------
## Other-subnet module call.
##------------------------------------------------------------------------------
module "subnets_other" {
  source              = "clouddrove/subnet/aws"
  version             = "2.0.0"
  name                = local.other_name
  environment         = local.other_environment
  availability_zones  = ["eu-west-2a", "eu-west-2b"]
  vpc_id              = module.vpc_other.vpc_id
  type                = "public"
  igw_id              = module.vpc_other.igw_id
  nat_gateway_enabled = false
  cidr_block          = module.vpc_other.vpc_cidr_block

}

##------------------------------------------------------------------------------
## transit-gateway module call.
##------------------------------------------------------------------------------
module "transit-gateway" {
  depends_on                      = [module.vpc, module.subnets]
  source                          = "./../../"
  name                            = local.name
  environment                     = local.environment
  tgw_create                      = true
  amazon_side_asn                 = 64512
  auto_accept_shared_attachments  = "enable"
  default_route_table_propagation = "enable"
  description                     = "This transit Gateway create for testing purpose"
  #TGW Share
  resource_share_enable                    = true
  resource_share_allow_external_principals = true
  resource_share_account_ids               = [""]
  # VPC Attachements
  vpc_attachments = {
    vpc1 = {
      vpc_id                                          = module.vpc.vpc_id
      subnet_ids                                      = module.subnets.public_subnet_id
      transit_gateway_default_route_table_association = false
      transit_gateway_default_route_table_propagation = false
      vpc_route_table_ids                             = module.subnets.public_route_tables_id
      destination_cidr                                = ["30.0.0.0/16", "50.0.0.0/16"]
    },
    vpc2 = {
      vpc_id                                          = module.vpc_other.vpc_id
      subnet_ids                                      = module.subnets_other.public_subnet_id
      transit_gateway_default_route_table_association = false
      transit_gateway_default_route_table_propagation = false
      vpc_route_table_ids                             = module.subnets_other.public_route_tables_id
      destination_cidr                                = ["31.0.0.0/16", "53.0.0.0/16"]
  } }
}

##------------------------------------------------------------------------------
## Transit-gateway module call for diff account. 
##------------------------------------------------------------------------------
module "transit-gateway" {
  depends_on                      = [module.vpc, module.subnets]
  source                          = "./../../"
  name                            = local.name
  environment                     = local.environment
  tgw_create                      = false
  amazon_side_asn                 = 64512
  auto_accept_shared_attachments  = "enable"
  default_route_table_propagation = "enable"
  description                     = "This transit Gateway create for testing purpose"
  #TGW Share
  resource_share_enable                    = true
  resource_share_allow_external_principals = true
  resource_share_account_ids               = [""]
  # VPC Attachements
  vpc_attachments = {
    vpc1 = {
      vpc_id                                          = module.vpc.vpc_id
      subnet_ids                                      = module.subnets.public_subnet_id
      transit_gateway_default_route_table_association = false
      transit_gateway_default_route_table_propagation = false
      vpc_route_table_ids                             = module.subnets.public_route_tables_id
      destination_cidr                                = ["30.0.0.0/16", "50.0.0.0/16"]
    },
    vpc2 = {
      vpc_id                                          = module.vpc_other.vpc_id
      subnet_ids                                      = module.subnets_other.public_subnet_id
      transit_gateway_default_route_table_association = false
      transit_gateway_default_route_table_propagation = false
      vpc_route_table_ids                             = module.subnets_other.public_route_tables_id
      destination_cidr                                = ["31.0.0.0/16", "53.0.0.0/16"]
  } }
}
