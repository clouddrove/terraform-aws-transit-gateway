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

  #Transit gateway invitation accepter
  aws_ram_resource_share_accepter = true
  resource_share_arn              = "arn:aws:ram:eu-west-1:XXXXXXXXXXX:resource-share/XXXXXXXXXXXXXXXXXXXXXXXXXX"

  # VPC Attachements
  vpc_attachement_create          = false # Enable After once create the subnets
  vpc_id                          = module.vpc.vpc_id
  use_existing_transit_gateway_id = true
  transit_gateway_id              = "tgw-XXXXXXXXXXX"
  destination_cidr_block          = ["10.0.0.0/8", "172.16.0.0/12"]
}