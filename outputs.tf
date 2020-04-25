#Module      : TRANSIT GATEWAY
#Description : Manages an EC2 Transit Gateway.

output "transit_gateway_id" {
  value       = join("", aws_ec2_transit_gateway.main.*.id)
  description = "The ID of the Transit Gateway."
}

output "resource_share_arn" {
  value       = join("", aws_ram_principal_association.main.*.resource_share_arn)
  description = "The ARN  of the RAM."
}

output "tags" {
  value       = module.labels.tags
  description = "A mapping of tags to assign to the resource."
}