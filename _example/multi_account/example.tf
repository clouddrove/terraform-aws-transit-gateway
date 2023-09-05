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
## Transit-gateway module call for diff account. 
##------------------------------------------------------------------------------
module "transit_gateway" {
  depends_on  = [module.vpc, module.subnets]
  source      = "./../../"
  name        = local.name
  environment = local.environment
  tgw_create  = false
  #TGW Share
  aws_ram_resource_share_accepter = true
  resource_share_arn              = "arn:aws:ram:eu-west-1:xxxxxxxxxx:resource-share/xxxxxxxxxxxxxxxxxxxxxxxxxx"
  # VPC Attachements
  transit_gateway_id = "tgw-xxxxxxxxxxx"
  vpc_attachments = {
    vpc1 = {
      vpc_id                                          = module.vpc.vpc_id
      subnet_ids                                      = module.subnets.public_subnet_id
      transit_gateway_default_route_table_association = true
      transit_gateway_default_route_table_propagation = true
      # Below should be uncommented only when vpc and subnet are already deployed.
      #vpc_route_table_ids                             = module.subnets.public_route_tables_id
      #destination_cidr                                = ["10.10.0.0/16"]
    }
  }
}
