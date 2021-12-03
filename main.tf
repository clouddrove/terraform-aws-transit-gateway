locals {
  vpc_attachments_without_default_route_table_association = {
    for k, v in var.vpc_attachments : k => v if lookup(v, "transit_gateway_default_route_table_association", true) != true
  }

  vpc_attachments_without_default_route_table_propagation = {
    for k, v in var.vpc_attachments : k => v if lookup(v, "transit_gateway_default_route_table_propagation", true) != true
  }

  # List of maps with key and route values
  vpc_attachments_with_routes = chunklist(flatten([
    for k, v in var.vpc_attachments : setproduct([{ key = k }], v["tgw_routes"]) if length(lookup(v, "tgw_routes", {})) > 0
  ]), 2)

  tgw_default_route_table_tags_merged = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
    var.tgw_default_route_table_tags,
  )



  vpc_route_table_destination_cidr = flatten([
    for k, v in var.vpc_attachments : [
      for rtb_id in lookup(v, "vpc_route_table_ids", []) : {
        rtb_id = rtb_id
        cidr   = v["tgw_destination_cidr"]
      }
    ]
  ])
}

module "labels" {
  source  = "clouddrove/labels/aws"
  version = "0.15.0"

  name        = var.name
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
}
#Module      : TRANSIT GATEWAY
#Description : Manages an EC2 Transit Gateway.
resource "aws_ec2_transit_gateway" "this" {
  count = var.create_tgw ? 1 : 0

  description                     = coalesce(var.description, var.name)
  amazon_side_asn                 = var.amazon_side_asn
  default_route_table_association = var.enable_default_route_table_association ? "enable" : "disable"
  default_route_table_propagation = var.enable_default_route_table_propagation ? "enable" : "disable"
  auto_accept_shared_attachments  = var.enable_auto_accept_shared_attachments ? "enable" : "disable"
  vpn_ecmp_support                = var.enable_vpn_ecmp_support ? "enable" : "disable"
  dns_support                     = var.enable_dns_support ? "enable" : "disable"

  tags = merge(
    {
      "Name" = module.labels.id
    },
    var.tags,
    var.tgw_tags,
    module.labels.tags

  )
}

resource "aws_ec2_tag" "this" {
  for_each    = var.create_tgw && var.enable_default_route_table_association ? local.tgw_default_route_table_tags_merged : {}
  resource_id = aws_ec2_transit_gateway.this[0].association_default_route_table_id
  key         = each.key
  value       = each.value
}


resource "aws_ec2_transit_gateway_route_table" "this" {
  count = var.create_tgw ? 1 : 0

  transit_gateway_id = aws_ec2_transit_gateway.this[0].id

  tags = merge(
    {
      "Name" = module.labels.id
    },
    var.tags,
    var.tgw_route_table_tags,
    module.labels.tags
  )
}

# VPC attachment routes
resource "aws_ec2_transit_gateway_route" "this" {
  count = length(local.vpc_attachments_with_routes)

  destination_cidr_block = local.vpc_attachments_with_routes[count.index][1]["destination_cidr_block"]
  blackhole              = lookup(local.vpc_attachments_with_routes[count.index][1], "blackhole", null)

  transit_gateway_route_table_id = var.create_tgw ? aws_ec2_transit_gateway_route_table.this[0].id : var.transit_gateway_route_table_id
  transit_gateway_attachment_id  = tobool(lookup(local.vpc_attachments_with_routes[count.index][1], "blackhole", false)) == false ? aws_ec2_transit_gateway_vpc_attachment.this[local.vpc_attachments_with_routes[count.index][0]["key"]].id : null
}

#Module      : AWS ROUTE
#Description : Provides a resource to create a routing table entry (a route) in a VPC routing table.
resource "aws_route" "this" {
  for_each = { for x in local.vpc_route_table_destination_cidr : x.rtb_id => x.cidr }

  route_table_id         = each.key
  destination_cidr_block = each.value
  transit_gateway_id     = aws_ec2_transit_gateway.this.*.id
}

data "aws_route_tables" "vpc-transit" {
  for_each = var.vpc_attachments
  vpc_id   = each.value["vpc_id"]
}

# locals {
#   route-table-list= flatten([
#     for key ,value in var.vpc_attachments : [

#     ]
#   ])
# }

# resource "aws_route" "vpc-transit" {
#   for_each = var.vpc_attachments
#   count = length(data.aws_route_tables.vpc-transit[each.key].ids)
#   route_table_id = tolist(data.aws_route_tables.vpc-transit[each.key].ids)[count.index]
#   transit_gateway_id     = aws_ec2_transit_gateway.this.*.id

#   dynamic "destination_cidr_block" {
#     for_each = { for x in local.vpc_route_table_destination_cidr : x.rtb_id => x.cidr }
#     content {
#       destination_cidr_block = each.value
#     }

#   }

# }

#Module      : TRANSIT GATEWAY VPC ATTACHMENT
#Description : Get information on an EC2 Transit Gateway VPC Attachment.
resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  for_each = var.vpc_attachments

  transit_gateway_id = lookup(each.value, "tgw_id", var.create_tgw ? aws_ec2_transit_gateway.this[0].id : null)
  vpc_id             = each.value["vpc_id"]
  subnet_ids         = each.value["subnet_ids"]

  dns_support                                     = lookup(each.value, "dns_support", true) ? "enable" : "disable"
  ipv6_support                                    = lookup(each.value, "ipv6_support", false) ? "enable" : "disable"
  appliance_mode_support                          = lookup(each.value, "appliance_mode_support", false) ? "enable" : "disable"
  transit_gateway_default_route_table_association = lookup(each.value, "transit_gateway_default_route_table_association", true)
  transit_gateway_default_route_table_propagation = lookup(each.value, "transit_gateway_default_route_table_propagation", true)

  tags = merge(
    {
      Name = format("%s-%s", var.name, each.key)
    },
    var.tags,
    var.tgw_vpc_attachment_tags,
    module.labels.tags
  )
}

resource "aws_ec2_transit_gateway_route_table_association" "this" {
  for_each = local.vpc_attachments_without_default_route_table_association

  # Create association if it was not set already by aws_ec2_transit_gateway_vpc_attachment resource
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this[each.key].id
  transit_gateway_route_table_id = coalesce(lookup(each.value, "transit_gateway_route_table_id", null), var.transit_gateway_route_table_id, aws_ec2_transit_gateway_route_table.this[0].id)
}

resource "aws_ec2_transit_gateway_route_table_propagation" "this" {
  for_each = local.vpc_attachments_without_default_route_table_propagation

  # Create association if it was not set already by aws_ec2_transit_gateway_vpc_attachment resource
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this[each.key].id
  transit_gateway_route_table_id = coalesce(lookup(each.value, "transit_gateway_route_table_id", null), var.transit_gateway_route_table_id, aws_ec2_transit_gateway_route_table.this[0].id)
}


#Module      : AWS RAM RESOURCE SHARE
#Description : Manages a Resource Access Manager (RAM) Resource Share. To association principals with the share.
resource "aws_ram_resource_share" "this" {
  count = var.create_tgw && var.share_tgw ? 1 : 0

  name                      = coalesce(var.ram_name, var.name)
  allow_external_principals = var.ram_allow_external_principals

  tags = merge(
    {
      "Name" = module.labels.id
    },
    var.tags,
    var.ram_tags,
    module.labels.tags
  )
}

#Module      : RAM PRINCIPAL ASSOCIATION
#Description : Provides a Resource Access Manager (RAM) principal association.
resource "aws_ram_resource_association" "this" {
  count = var.create_tgw && var.share_tgw ? 1 : 0

  resource_arn       = aws_ec2_transit_gateway.this[0].arn
  resource_share_arn = aws_ram_resource_share.this[0].id
}


#Module      : RAM ASSOCIATION
#Description : Manages a Resource Access Manager (RAM) Resource Association.
resource "aws_ram_principal_association" "this" {
  count = var.create_tgw && var.share_tgw ? length(var.ram_principals) : 0

  principal          = var.ram_principals[count.index]
  resource_share_arn = aws_ram_resource_share.this[0].arn
}

resource "aws_ram_resource_share_accepter" "this" {
  count = !var.create_tgw && var.share_tgw ? 1 : 0

  share_arn = var.ram_resource_share_arn
}
