output "tags" {
  value       = module.transit_gateway.tags
  description = "A mapping of tags to assign to the transit-gateway."
}

output "ram_resource_share_id" {
  value       = module.transit_gateway.ram_resource_share_id
  description = "The Amazon Resource Name (ARN) of the resource share"
}

output "ec2_transit_gateway_association_default_route_table_id" {
  value       = module.transit_gateway.ec2_transit_gateway_association_default_route_table_id
  description = "Identifier of the default association route table"
}

output "ec2_transit_gateway_vpc_attachment_ids" {
  value       = module.transit_gateway.ec2_transit_gateway_vpc_attachment_ids
  description = "List of EC2 Transit Gateway VPC Attachment identifiers"
}
