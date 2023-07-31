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
