#Module      : TRANSIT GATEWAY
#Description : Terraform module which creates transit gateway resources on AWS
output "transit_gateway_id" {
  value       = "${aws_ec2_transit_gateway.tgw.id}"
  description = "The ID of the Transit Gateway"
}

output "transit_gateway_arn" {
  value       = "${aws_ec2_transit_gateway.tgw.arn}"
  description = "The ANR of the Transit Gateway"
}

output "transit_gateway_association_route_table_id" {
  value       = "${aws_ec2_transit_gateway.tgw.association_default_route_table_id}"
  description = "The ANR of the Transit Gateway"
}

output "transit_gateway_propagation_route_table_id" {
  value       = "${aws_ec2_transit_gateway.tgw.propagation_default_route_table_id}"
  description = "The ANR of the Transit Gateway"
}