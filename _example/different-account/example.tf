provider "aws" {
  region = "eu-west-1"
}

# This provider is required for attachment only installation in another AWS Account.
provider "aws" {
  region = "eu-west-2"
  alias  = "peer"
}

# See Notes in README.md for explanation regarding using data-sources and computed values

module "tgw" {
  source = "../../"

  name            = "my-tgw"
  environment     = "test"
  label_order     = ["environment", "name"]
  description     = "My TGW shared with several other AWS accounts"
  amazon_side_asn = 64532

  enable_auto_accept_shared_attachments = true # When "true" there is no need for RAM resources if using multiple AWS accounts

  vpc_attachments = {
    vpc1 = {
      vpc_id                                          = module.vpc1.vpc_id
      subnet_ids                                      = module.subnets1.public_subnet_id
      dns_support                                     = true
      ipv6_support                                    = true
      transit_gateway_default_route_table_association = true
      transit_gateway_default_route_table_propagation = true


      tgw_routes = [
        {
          destination_cidr_block = "30.0.0.0/16"
        },
        {
          blackhole              = true
          destination_cidr_block = "0.0.0.0/0"
        }
      ]
    },
    vpc2 = {
      vpc_id     = module.vpc1.vpc_id
      subnet_ids = module.subnets1.public_subnet_id

      tgw_routes = [
        {
          destination_cidr_block = "50.0.0.0/16"
        },
        {
          blackhole              = true
          destination_cidr_block = "10.10.10.10/32"
        }
      ]
    },
  }

  ram_allow_external_principals = true
  ram_principals                = [307990089504]

  tags = {
    Purpose = "tgw-muti-acc"
  }
}

module "tgw_peer" {
  # This is optional and connects to another account. Meaning you need to be authenticated with 2 separate AWS Accounts
  source = "../../"

  providers = {
    aws = aws.peer
  }

  name            = "my-tgw-peer"
  description     = "My TGW shared with several other AWS accounts"
  amazon_side_asn = 64532

  share_tgw                             = true
  create_tgw                            = false
  ram_resource_share_arn                = module.tgw.ram_resource_share_id
  enable_auto_accept_shared_attachments = true # When "true" there is no need for RAM resources if using multiple AWS accounts
  transit_gateway_route_table_id        = "tgw-rtb-0xxxxxxxxx"
  vpc_attachments = {
    vpc1 = {
      tgw_id                                          = module.tgw.ec2_transit_gateway_id
      vpc_id                                          = module.vpc1.vpc_id
      subnet_ids                                      = module.subnets1.public_subnet_id
      dns_support                                     = true
      ipv6_support                                    = true
      transit_gateway_default_route_table_association = true
      transit_gateway_default_route_table_propagation = true


      tgw_routes = [
        {
          destination_cidr_block = "30.0.0.0/16"
        },
        {
          blackhole              = true
          destination_cidr_block = "0.0.0.0/0"
        }
      ]
    },
  }

  ram_allow_external_principals = true
  ram_principals                = [307990089504]

  tags = {
    Purpose = "tgw-multi-acc"
  }
}


module "vpc1" {
  source  = "clouddrove/vpc/aws"
  version = "0.15.0"

  name        = "vpc"
  environment = "test"
  label_order = ["environment", "name"]
  cidr_block  = "10.10.0.0/16"
}

module "subnets1" {
  source  = "clouddrove/subnet/aws"
  version = "0.15.0"

  name                = "subnets"
  environment         = "test"
  label_order         = ["environment", "name"]
  availability_zones  = ["eu-west-1b"]
  vpc_id              = module.vpc1.vpc_id
  type                = "public"
  igw_id              = module.vpc1.igw_id
  nat_gateway_enabled = false
  cidr_block          = module.vpc1.vpc_cidr_block
  ipv6_cidr_block     = module.vpc1.ipv6_cidr_block
}

module "vpc2" {
  source  = "clouddrove/vpc/aws"
  version = "0.15.0"

  name        = "vpc2"
  environment = "test"
  label_order = ["environment", "name"]
  cidr_block  = "10.0.0.0/16"

}

module "subnets2" {
  source  = "clouddrove/subnet/aws"
  version = "0.15.0"

  name                = "subnets2"
  environment         = "test"
  label_order         = ["environment", "name"]
  availability_zones  = ["eu-west-1a", ]
  vpc_id              = module.vpc2.vpc_id
  type                = "public"
  igw_id              = module.vpc2.igw_id
  nat_gateway_enabled = false
  cidr_block          = module.vpc2.vpc_cidr_block
  ipv6_cidr_block     = module.vpc2.ipv6_cidr_block
}

