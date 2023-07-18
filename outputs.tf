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

output "ec2_transit_gateway_arn" {
  value       = try(aws_ec2_transit_gateway.main[0].arn, "")
  description = "EC2 Transit Gateway Amazon Resource Name (ARN)"
}

output "ec2_transit_gateway_route_table_id" {
  value       = try(aws_ec2_transit_gateway_route_table.this[0].id, "")
  description = "EC2 Transit Gateway Route Table identifier"
}

output "ec2_transit_gateway_vpc_attachment" {
  value       = aws_ec2_transit_gateway_vpc_attachment.main
  description = "Map of EC2 Transit Gateway VPC Attachment attributes"
}

output "ram_resource_share_id" {
  value       = try(aws_ram_resource_share.main[0].id, "")
  description = "The Amazon Resource Name (ARN) of the resource share"
}