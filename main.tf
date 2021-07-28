# Managed By : CloudDrove
# Description : This Script is used to create Transit Gateway.
# Copyright @ CloudDrove. All Right Reserved.

#Module      : Label
#Description : This terraform module is designed to generate consistent label names and tags
#              for resources. You can use terraform-labels to implement a strict naming
#              convention.
module "labels" {
  source  = "clouddrove/labels/aws"
  version = "0.15.0"

  enabled     = var.enable
  name        = var.name
  repository  = var.repository
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
}

#Module      : TRANSIT GATEWAY
#Description : Manages an EC2 Transit Gateway.
resource "aws_ec2_transit_gateway" "main" {
  count = var.enable && var.tgw_create ? 1 : 0

  description                     = var.description
  vpn_ecmp_support                = var.vpn_ecmp_support
  amazon_side_asn                 = var.amazon_side_asn
  default_route_table_association = var.default_route_table_association
  auto_accept_shared_attachments  = var.auto_accept_shared_attachments
  default_route_table_propagation = var.default_route_table_propagation
  tags                            = module.labels.tags
}

data "aws_subnet_ids" "main" {
  count  = var.enable && var.vpc_attachement_create ? 1 : 0
  vpc_id = var.vpc_id
}

#Module      : TRANSIT GATEWAY VPC ATTACHMENT
#Description : Get information on an EC2 Transit Gateway VPC Attachment.
resource "aws_ec2_transit_gateway_vpc_attachment" "main" {
  count = var.enable && var.vpc_attachement_create ? 1 : 0

  transit_gateway_id                              = var.use_existing_transit_gateway_id == false ? join("", aws_ec2_transit_gateway.main.*.id) : var.transit_gateway_id
  subnet_ids                                      = element(data.aws_subnet_ids.main.*.ids, count.index)
  vpc_id                                          = var.vpc_id
  transit_gateway_default_route_table_association = var.transit_gateway_default_route_table_association
  transit_gateway_default_route_table_propagation = var.transit_gateway_default_route_table_propagation
  tags = merge(
    module.labels.tags,
    {
      "Name" = format("%s-vpc-attachment", module.labels.id)
    }
  )

  depends_on = [
    data.aws_subnet_ids.main
  ]
}

#Module      : AWS RAM RESOURCE SHARE
#Description : Manages a Resource Access Manager (RAM) Resource Share. To association principals with the share.
resource "aws_ram_resource_share" "main" {
  count = var.enable && var.resource_share_enable ? 1 : 0

  name                      = format("%s-share", module.labels.id)
  allow_external_principals = var.resource_share_allow_external_principals
  tags = merge(
    module.labels.tags,
    {
      "Name" = format("%s-share", module.labels.id)
    }
  )
}

#Module      : RAM PRINCIPAL ASSOCIATION
#Description : Provides a Resource Access Manager (RAM) principal association.
resource "aws_ram_principal_association" "main" {
  count = var.enable && var.resource_share_enable ? length(var.resource_share_account_ids) : 0

  principal          = element(var.resource_share_account_ids, count.index)
  resource_share_arn = join("", aws_ram_resource_share.main.*.id)
}

#Module      : RAM ASSOCIATION
#Description : Manages a Resource Access Manager (RAM) Resource Association.
resource "aws_ram_resource_association" "main" {
  count = var.enable && var.resource_share_enable ? 1 : 0

  resource_arn       = join("", aws_ec2_transit_gateway.main.*.arn)
  resource_share_arn = join("", aws_ram_resource_share.main.*.id)
}

data "aws_route_tables" "main" {
  count  = var.enable && var.vpc_attachement_create ? 1 : 0
  vpc_id = var.vpc_id

  filter {
    name   = "tag:Application"
  }
}

#Module      : AWS ROUTE
#Description : Provides a resource to create a routing table entry (a route) in a VPC routing table.
resource "aws_route" "main" {
  count = var.enable && var.vpc_attachement_create ? length(distinct(sort(data.aws_route_tables.main[0].ids)), ) * length(var.destination_cidr_block) : 0

  route_table_id         = element(distinct(sort(data.aws_route_tables.main[0].ids)), count.index)
  destination_cidr_block = element(distinct(sort(var.destination_cidr_block)), ceil(count.index / length(var.destination_cidr_block), ), )
  transit_gateway_id     = var.use_existing_transit_gateway_id == false ? join("", aws_ec2_transit_gateway.main.*.id) : var.transit_gateway_id
  depends_on = [
    data.aws_route_tables.main,
    data.aws_subnet_ids.main,
    aws_ec2_transit_gateway_vpc_attachment.main,
  ]
}

resource "aws_ram_resource_share_accepter" "receiver_accept" {
  count     = var.enable && var.aws_ram_resource_share_accepter ? 1 : 0
  share_arn = var.resource_share_arn
}