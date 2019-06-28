## Managed By : CloudDrove
## Copyright @ CloudDrove. All Right Reserved.

#Module      : label
#Description : Terraform module to create consistent naming for multiple names.

module "labels" {
  source      = "git::https://github.com/clouddrove/terraform-labels.git"
  name        = var.name
  application = var.application
  environment = var.environment
  label_order = var.label_order
}

#Module      : TRANSIT GATEWAY
#Description : Manages an EC2 Transit Gateway.
resource "aws_ec2_transit_gateway" "tgw" {
  #count  = var.create_tgw == "true" ? 1 : 0
  description = "Transit Gateway"

  auto_accept_shared_attachments  = var.auto_accept_shared_attachments
  default_route_table_association = var.default_route_table_association
  default_route_table_propagation = var.default_route_table_propagation

  dns_support      = var.dns_support
  vpn_ecmp_support = var.vpn_ecmp_support

  tags = module.labels.tags
}


