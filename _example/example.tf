provider "aws" {
  region = "eu-west-1"
}

## ONE Environment

module "vpc_one" {
  source = "git::https://github.com/clouddrove/terraform-aws-vpc.git"

  name        = "vpc1-dev"
  application = "test"
  environment = "dev"
  label_order = ["environment", "name", "application"]

  cidr_block = "10.1.0.0/16"
}

module "vpc_two" {
  source = "git::https://github.com/clouddrove/terraform-aws-vpc.git"

  name        = "vpc2-dev"
  application = "test"
  environment = "dev"
  label_order = ["environment", "name", "application"]

  cidr_block = "10.2.0.0/16"
}

module "vpc_three" {
  source = "git::https://github.com/clouddrove/terraform-aws-vpc.git"

  name        = "vpc2-shared"
  application = "test"
  environment = "dev"
  label_order = ["environment", "name", "application"]

  cidr_block = "10.3.0.0/16"
}

locals {
  one_public_cidr_block   = "${cidrsubnet(module.vpc_one.vpc_cidr_block, 1, 0)}"
  two_public_cidr_block   = "${cidrsubnet(module.vpc_two.vpc_cidr_block, 1, 0)}"
  three_public_cidr_block = "${cidrsubnet(module.vpc_three.vpc_cidr_block, 1, 0)}"
}



module "subnets_one" {
  //source = "git::https://github.com/clouddrove/terraform-aws-public-subnet.git?ref=tags/0.11.0"
  source = "./../../_terraform/terraform-aws-subnet"

  name        = "subnet1-dev"
  application = "test"
  environment = "dev"
  label_order = ["environment", "name", "application"]

  availability_zones  = ["eu-west-1a", "eu-west-1c"]
  vpc_id              = module.vpc_one.vpc_id
  cidr_block          = local.one_public_cidr_block
  type                = "public"
  igw_id              = module.vpc_one.igw_id
  nat_gateway_enabled = "false"
}


module "subnets_two" {
  //source = "git::https://github.com/clouddrove/terraform-aws-public-subnet.git?ref=tags/0.11.0"
  source = "./../../_terraform/terraform-aws-subnet"

  name        = "subnet2-dev"
  application = "test"
  environment = "dev"
  label_order = ["environment", "name", "application"]

  availability_zones  = ["eu-west-1b", "eu-west-1c"]
  vpc_id              = module.vpc_two.vpc_id
  cidr_block          = local.two_public_cidr_block
  type                = "public"
  igw_id              = module.vpc_two.igw_id
  nat_gateway_enabled = "false"
}


module "subnets_three" {
  //source = "git::https://github.com/clouddrove/terraform-aws-public-subnet.git?ref=tags/0.11.0"
  source = "./../../_terraform/terraform-aws-subnet"

  name        = "subnet2-dev"
  application = "test"
  environment = "dev"
  label_order = ["environment", "name", "application"]

  availability_zones  = ["eu-west-1b", "eu-west-1c"]
  vpc_id              = module.vpc_three.vpc_id
  cidr_block          = local.three_public_cidr_block
  type                = "public"
  igw_id              = module.vpc_three.igw_id
  nat_gateway_enabled = "false"
}

module "transit_gateway" {

  source = "../"

  name        = "transit"
  application = "test"
  environment = "dev"
  label_order = ["environment", "name", "application"]

}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc-one_tgw_attachment" {
  subnet_ids         = [module.subnets_one.public_subnet_id[1]]
  transit_gateway_id = module.transit_gateway.transit_gateway_id
  vpc_id             = module.vpc_one.vpc_id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc-two_tgw_attachment" {
  subnet_ids         = [module.subnets_two.public_subnet_id[1]]
  transit_gateway_id = module.transit_gateway.transit_gateway_id
  vpc_id             = module.vpc_two.vpc_id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc-three_tgw_attachment" {
  subnet_ids         = [module.subnets_three.public_subnet_id[1]]
  transit_gateway_id = module.transit_gateway.transit_gateway_id
  vpc_id             = module.vpc_three.vpc_id
}

resource "aws_route" "tgw-route-one" {
  route_table_id         = module.subnets_one.public_subnet_route_table[1]
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id     = module.transit_gateway.transit_gateway_id
}

resource "aws_route" "tgw-route-two" {
  route_table_id         = module.subnets_two.public_subnet_route_table[1]
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id     = module.transit_gateway.transit_gateway_id
}

resource "aws_route" "tgw-route-three" {
  route_table_id         = module.subnets_three.public_subnet_route_table[1]
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id     = module.transit_gateway.transit_gateway_id
}

