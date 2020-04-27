provider "aws" {
  region = "eu-west-1"
}

module "vpc" {
  source = "git::https://github.com/clouddrove/terraform-aws-vpc.git?ref=tags/0.12.4"

  name        = "vpc"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "application", "name"]
  cidr_block  = "172.16.0.0/16"
}

module "subnets" {
  source      = "git::https://github.com/clouddrove/terraform-aws-subnet.git?ref=tags/0.12.4"
  name        = "subnets"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "name", "application"]

  availability_zones  = ["eu-west-1a", "eu-west-1b"]
  vpc_id              = module.vpc.vpc_id
  type                = "public"
  igw_id              = module.vpc.igw_id
  nat_gateway_enabled = false
  cidr_block          = module.vpc.vpc_cidr_block
}

module "transit-gateway" {
  source      = "./../../"
  name        = "transit-gateway"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "application", "name"]

  amazon_side_asn                 = 64512
  auto_accept_shared_attachments  = "enable"
  default_route_table_propagation = "enable"
  description                     = "This transit Gateway create for testing purpose"

  #TGW Share
  resource_share_enable                    = true
  resource_share_allow_external_principals = true
  resource_share_account_ids               = ["XXXXXXXXXXXXX"]

  # VPC Attachements
  vpc_attachement_create = false # Enable After once create the subnets
  vpc_id                 = module.vpc.vpc_id
  destination_cidr_block = ["10.20.0.0/16"]
}

module "vpc-attachement" {
  source      = "./../../"
  name        = "transit-gateway"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "application", "name"]

  # VPC Attachements
  vpc_id                          = module.vpc-other.vpc_id
  destination_cidr_block          = ["10.10.0.0/16"]
  vpc_attachement_create          = false # Enable After once create the subnets
  use_existing_transit_gateway_id = true
  transit_gateway_id              = module.transit-gateway.transit_gateway_id

  #Transit gateway invitation accepter
  aws_ram_resource_share_accepter = true
  resource_share_arn              = module.transit-gateway.resource_share_arn
}