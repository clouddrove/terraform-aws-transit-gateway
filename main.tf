## Managed By : CloudDrove
## Copyright @ CloudDrove. All Right Reserved.

#Module      : label
#Description : Terraform module to create consistent naming for multiple names.

module "labels" {
  source      = "git::https://github.com/clouddrove/terraform-labels.git?ref=master"
  name        = var.name
  application = var.application
  environment = var.environment
  label_order = var.label_order
}

#Module      : TRANSIT GATEWAY
#Description : Manages an EC2 Transit Gateway.
resource "aws_ec2_transit_gateway" "tgw" {
  description = "Transit Gateway"

  default_route_table_association = var.default_route_table_association
  default_route_table_propagation = var.default_route_table_propagation
  auto_accept_shared_attachments  = var.auto_accept_shared_attachments

  tags = module.labels.tags
}

#Module      : ATTACHMENT
#Description : Manages an EC2 Transit Gateway VPC Attachment.

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc-tgw_attachment" {
  subnet_ids         = var.subnet_ids
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = var.vpc_id
  tags               = module.labels.tags
}

#Module      : ROUTE
#Description : Provides a resource to create a routing table entry (a route) in a VPC routing table.
resource "aws_route" "tgw-route" {
  route_table_id         = var.route_table_id
  destination_cidr_block = var.destination_cidr_block
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
}


