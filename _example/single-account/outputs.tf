output "transit_gateway_id" {
  value       = module.transit-gateway[*].transit_gateway_id
  description = "The ID of the transit-gateway."
}

output "tags" {
  value       = module.transit-gateway.tags
  description = "A mapping of tags to assign to the transit-gateway."
}

output "ec2_transit_gateway_arn" {
  value       = module.transit-gateway.ec2_transit_gateway_arn
  description = "EC2 Transit Gateway Amazon Resource Name (ARN)"
}

output "ec2_transit_gateway_route_table_id" {
  value       = module.transit-gateway.ec2_transit_gateway_route_table_id
  description = "EC2 Transit Gateway Route Table identifier"
}

output "ec2_transit_gateway_owner_id" {
  value       = module.transit-gateway.ec2_transit_gateway_owner_id
  description = "Identifier of the AWS account that owns the EC2 Transit Gateway"
}

output "ec2_transit_gateway_association_default_route_table_id" {
  value       = module.transit-gateway.ec2_transit_gateway_association_default_route_table_id
  description = "Identifier of the default association route table"
}

output "ec2_transit_gateway_vpc_attachment_ids" {
  value       = module.transit-gateway.ec2_transit_gateway_vpc_attachment_ids
  description = "List of EC2 Transit Gateway VPC Attachment identifiers"
}

output "ram_resource_share_id" {
  value       = module.transit-gateway.ram_resource_share_id
  description = "The Amazon Resource Name (ARN) of the resource share"
}
