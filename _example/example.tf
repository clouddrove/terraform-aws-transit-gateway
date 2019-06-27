provider "aws" {
  region = "eu-west-1"
}

## ONE Environment
module "one_keypair" {
  source = "git::https://github.com/clouddrove/terraform-aws-keypair.git?ref=master"

  key             = "${file("~/.ssh/id_rsa.pub")}"
  key_name        = "one-main-key"
  create_key_pair = "true"
}

locals {
  one_public_cidr_block = "${cidrsubnet(module.vpc_one.vpc_cidr_block, 1, 0)}"
}

module "vpc_one" {
  source = "git::https://github.com/clouddrove/terraform-aws-vpc.git?ref=master"

  name        = "terraform-vpc-one"
  application = "test"
  environment = "dev"
  label_order = ["environment", "name", "application"]

  cidr_block = "10.1.0.0/16"
}

module "subnets_one" {
  //source = "git::https://github.com/clouddrove/terraform-aws-public-subnet.git?ref=tags/0.11.0"
  source = "./../../_terraform/terraform-aws-subnet"

  name        = "terraform-subnet-one"
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


## TWO Environment
module "two_keypair" {
  source = "git::https://github.com/clouddrove/terraform-aws-keypair.git?ref=master"

  key             = "${file("~/.ssh/id_rsa.pub")}"
  key_name        = "two-main-key"
  create_key_pair = "true"
}

locals {
  two_public_cidr_block = "${cidrsubnet(module.vpc_two.vpc_cidr_block, 1, 0)}"
}

module "vpc_two" {
  source = "git::https://github.com/clouddrove/terraform-aws-vpc.git?ref=master"

  name        = "terraform-vpc-two"
  application = "test"
  environment = "dev"
  label_order = ["environment", "name", "application"]

  cidr_block = "10.1.0.0/16"
}

module "subnets_two" {
  //source = "git::https://github.com/clouddrove/terraform-aws-public-subnet.git?ref=tags/0.11.0"
  source = "./../../_terraform/terraform-aws-subnet"

  name        = "terraform-subnet-two"
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

module "transit_gateway" {

  source = "../"

  name        = "transit"
  application = "test"
  environment = "dev"
  label_order = ["environment", "name", "application"]

  subnet_ids = [module.subnets_one.public_subnet_id[1]]
  vpc_id     = module.vpc_one.vpc_id

  route_table_id         = module.subnets_one.public_subnet_route_table[1]
  destination_cidr_block = "10.0.0.0/8"

}

module "transit_gateway2" {

  source = "../"

  name                            = "transit"
  application                     = "test"
  environment                     = "dev"
  label_order                     = ["environment", "name", "application"]
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  auto_accept_shared_attachments  = "enable"

  subnet_ids = [module.subnets_two.public_subnet_id[1]]
  vpc_id     = module.vpc_two.vpc_id


  route_table_id         = module.subnets_two.public_subnet_route_table[1]
  destination_cidr_block = "10.0.0.0/8"
}


