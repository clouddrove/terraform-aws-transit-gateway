output "transit_gateway_id" {
  value       = aws_ec2_transit_gateway.tgw.id
  description = "The ID of the Transit Gateway"
}

output "transit_gateway_arn" {
  value       = aws_ec2_transit_gateway.tgw.arn
  description = "The ANR of the Transit Gateway"
}
