provider "aws" {
  region = "eu-west-1"
}

module "vpc" {
  source  = "clouddrove/vpc/aws"
  version = "1.3.0"

  name        = "vpc"
  environment = "test"
  label_order = ["environment", "name"]
  cidr_block  = "10.10.0.0/16"
}

module "subnets" {
  source  = "clouddrove/subnet/aws"
  version = "1.3.0"

  name                = "subnets"
  environment         = "test"
  label_order         = ["environment", "name"]
  availability_zones  = ["eu-west-1a", "eu-west-1b"]
  vpc_id              = module.vpc.vpc_id
  type                = "public"
  igw_id              = module.vpc.igw_id
  nat_gateway_enabled = false
  cidr_block          = module.vpc.vpc_cidr_block
  ipv6_cidr_block     = module.vpc.ipv6_cidr_block
}

module "vpc-other" {
  source  = "clouddrove/vpc/aws"
  version = "1.3.0"

  name        = "vpc"
  environment = "test"
  label_order = ["environment", "name"]

  cidr_block = "192.168.0.0/16"
}

module "subnets-other" {
  source              = "clouddrove/subnet/aws"
  version = "1.3.0"

  name                = "subnets"
  environment         = "test"
  label_order         = ["environment", "name"]
  availability_zones  = ["eu-west-1a", "eu-west-1b"]
  vpc_id              = module.vpc-other.vpc_id
  type                = "public"
  igw_id              = module.vpc-other.igw_id
  nat_gateway_enabled = false
  cidr_block          = module.vpc-other.vpc_cidr_block
  ipv6_cidr_block     = module.vpc-other.ipv6_cidr_block

}

module "transit-gateway" {
  source = "./../../"

  name        = "transit-gateway"
  environment = "test"
  label_order = ["environment", "name"]
  enable      = true
  tgw_create  = true

  amazon_side_asn                 = 64512
  auto_accept_shared_attachments  = "enable"
  default_route_table_propagation = "enable"
  description                     = "This transit Gateway create for testing purpose"

  #TGW Share
  resource_share_enable                    = false
  resource_share_allow_external_principals = true
  resource_share_account_ids               = ["XXXXXXXXXXXXX"]
  subnet_ids                               = module.subnets.private_subnet_id
  
  # VPC Attachements
  vpc_attachement_create = false # Enable After once create the subnets
  vpc_id                 = module.vpc.vpc_id
  destination_cidr_block = ["192.168.0.0/16"]

}

module "vpc-attachement" {
  source      = "./../../"
  name        = "transit-gateway"
  environment = "test"
  label_order = ["environment", "name"]

  # VPC Attachements
  vpc_id                          = module.vpc-other.vpc_id
  destination_cidr_block          = ["10.10.0.0/16"]
  vpc_attachement_create          = false # Enable After once create the subnets
  use_existing_transit_gateway_id = true
  transit_gateway_id              = module.transit-gateway.transit_gateway_id
}