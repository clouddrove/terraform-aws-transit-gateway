output "transit_gateway_id" {
  value       = module.transit-gateway.*.transit_gateway_id
  description = "The ID of the transit-gateway."
}

output "tags" {
  value       = module.transit-gateway.tags
  description = "A mapping of tags to assign to the transit-gateway."
}

output "resource_share_arn" {
  value       = module.transit-gateway.resource_share_arn
  description = "The ARN  of the RAM."
}
