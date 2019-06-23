output "transit_gateway_id" {
  value       = "${aws_ec2_transit_gateway.transit-gateway.id}"
  description = "The ID of the Transit Gateway"
}

output "transit_gateway_anr" {
  value       = "${aws_ec2_transit_gateway.transit-gateway.arn}"
  description = "The ANR of the Transit Gateway"
}
