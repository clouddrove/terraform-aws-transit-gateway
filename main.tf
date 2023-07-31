##------------------------------------------------------------------------------
## Labels module callled that will be used for naming and tags.
##------------------------------------------------------------------------------
module "labels" {
  source  = "clouddrove/labels/aws"
  version = "1.3.0"

  enabled     = var.enable
  name        = var.name
  repository  = var.repository
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
}

##------------------------------------------------------------------------------
## A transit gateway acts as a Regional virtual router for traffic flowing between your virtual private clouds (VPCs) and on-premises networks.
##------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway" "main" {
  count = var.enable && var.tgw_create ? 1 : 0

  description                     = var.description
  vpn_ecmp_support                = var.vpn_ecmp_support
  amazon_side_asn                 = var.amazon_side_asn
  default_route_table_association = var.default_route_table_association
  auto_accept_shared_attachments  = var.auto_accept_shared_attachments
  default_route_table_propagation = var.default_route_table_propagation
  transit_gateway_cidr_blocks     = var.transit_gateway_cidr_blocks
  dns_support                     = var.dns_support
  multicast_support               = var.multicast_support
  tags                            = module.labels.tags
}

##------------------------------------------------------------------------------
## Get information on an EC2 Transit Gateway VPC Attachment.
##------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment" "main" {
  count = var.enable && var.vpc_attachement_create ? 1 : 0

  transit_gateway_id                              = var.use_existing_transit_gateway_id == false ? join("", aws_ec2_transit_gateway.main[*].id) : var.transit_gateway_id
  subnet_ids                                      = var.subnet_ids
  vpc_id                                          = var.vpc_id
  transit_gateway_default_route_table_association = var.transit_gateway_default_route_table_association
  transit_gateway_default_route_table_propagation = var.transit_gateway_default_route_table_propagation
  tags = merge(
    module.labels.tags,
    {
      "Name" = format("%s-vpc-attachment", module.labels.id)
    }
  )
}

##------------------------------------------------------------------------------
## You can use AWS Resource Access Manager (RAM) to share a transit gateway for VPC attachments across accounts or across your organization in AWS.
##------------------------------------------------------------------------------
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

##------------------------------------------------------------------------------
## Provides a Resource Access Manager (RAM) principal association. Depending if RAM Sharing with AWS Organizations is enabled, the RAM behavior with different principal types changes.
##------------------------------------------------------------------------------
resource "aws_ram_principal_association" "main" {
  count = var.enable && var.resource_share_enable ? length(var.resource_share_account_ids) : 0

  principal          = element(var.resource_share_account_ids, count.index)
  resource_share_arn = join("", aws_ram_resource_share.main[*].id)
}

##------------------------------------------------------------------------------
## The Resource Association in AWS RAM can be configured in Terraform with the resource name aws_ram_resource_association.
##------------------------------------------------------------------------------
resource "aws_ram_resource_association" "main" {
  count = var.enable && var.resource_share_enable ? 1 : 0

  resource_arn       = aws_ec2_transit_gateway.main[0].arn
  resource_share_arn = aws_ram_resource_share.main[0].arn
}

data "aws_route_tables" "main" {
  count  = var.enable && var.vpc_attachement_create ? 1 : 0
  vpc_id = var.vpc_id
}

##------------------------------------------------------------------------------
## Provides a resource to create a routing table entry (a route) in a VPC routing table.
##------------------------------------------------------------------------------
resource "aws_route" "main" {
  count = var.enable && var.vpc_attachement_create ? length(distinct(sort(data.aws_route_tables.main[0].ids)), ) * length(var.destination_cidr_block) : 0

  route_table_id         = element(distinct(sort(data.aws_route_tables.main[0].ids)), count.index)
  destination_cidr_block = element(distinct(sort(var.destination_cidr_block)), ceil(count.index / length(var.destination_cidr_block), ), )
  transit_gateway_id     = var.use_existing_transit_gateway_id == false ? join("", aws_ec2_transit_gateway.main[*].id) : var.transit_gateway_id
  depends_on = [
    data.aws_route_tables.main,
    aws_ec2_transit_gateway_vpc_attachment.main,
  ]
}

##------------------------------------------------------------------------------
## An AWS Transit Gateway Route Table includes dynamic routes, static routes and blackhole routes.
##------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table" "this" {
  count = var.tgw_create ? 1 : 0

  transit_gateway_id = aws_ec2_transit_gateway.main[0].id

  tags = merge(
    module.labels.tags,
    { Name = var.name },
  )
}

##------------------------------------------------------------------------------
## Associates the specified attachment with the specified transit gateway route table. You can associate one route table with an attachment.
##------------------------------------------------------------------------------
resource "aws_ram_resource_share_accepter" "receiver_accept" {
  count     = var.enable && var.aws_ram_resource_share_accepter ? 1 : 0
  share_arn = var.resource_share_arn
}

