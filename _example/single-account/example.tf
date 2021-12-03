provider "aws" {
  region = "eu-west-1"
}



module "tgw" {
  source = "../../"

  name                                  = "my-tgw"
  environment                           = "test"
  label_order                           = ["environment", "name"]
  description                           = "My TGW shared with several other AWS accounts"
  amazon_side_asn                       = 64532
  enable_auto_accept_shared_attachments = true # When "true" there is no need for RAM resources if using multiple AWS accounts


  vpc_attachments = {

    vpc1 = {
      vpc_id                                          = module.vpc.vpc_id
      subnet_ids                                      = module.subnets.public_subnet_id
      dns_support                                     = true
      ipv6_support                                    = true
      transit_gateway_default_route_table_association = true
      transit_gateway_default_route_table_propagation = true


      tgw_routes = [
        {
          destination_cidr_block = "10.0.0.0/16"
        },
        {
          blackhole              = true
          destination_cidr_block = "0.0.0.0/0"
        }
      ]
    },
    vpc2 = {
      vpc_id                                          = module.vpc2.vpc_id               #data.aws_vpc.default.id  
      subnet_ids                                      = module.subnets2.public_subnet_id #data.aws_subnet_ids.this.ids 
      transit_gateway_default_route_table_association = true
      transit_gateway_default_route_table_propagation = true

      tgw_routes = [
        {
          destination_cidr_block = "10.10.0.0/16"
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
    Purpose = "tgw-complete-example"
  }
}

module "vpc" {
  source  = "clouddrove/vpc/aws"
  version = "0.15.0"

  name        = "vpc"
  environment = "test"
  label_order = ["environment", "name"]
  cidr_block  = "10.10.0.0/16"
}

module "subnets" {
  source  = "clouddrove/subnet/aws"
  version = "0.15.0"

  name                = "subnets"
  environment         = "test"
  label_order         = ["environment", "name"]
  availability_zones  = ["eu-west-1b"]
  vpc_id              = module.vpc.vpc_id
  type                = "public"
  igw_id              = module.vpc.igw_id
  nat_gateway_enabled = false
  cidr_block          = module.vpc.vpc_cidr_block
  ipv6_cidr_block     = module.vpc.ipv6_cidr_block
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
