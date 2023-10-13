#Module      : LABEL
#Description : Terraform label module variables.
variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "repository" {
  type        = string
  default     = "https://github.com/clouddrove/terraform-aws-transit-gateway"
  description = "Terraform current module repo"
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "label_order" {
  type        = list(any)
  default     = ["environment", "name"]
  description = "Label order, e.g. `name`."
}

variable "managedby" {
  type        = string
  default     = "anmol@clouddrove.com"
  description = "ManagedBy, eg 'CloudDrove' or 'AnmolNagpal'."
}

variable "enable" {
  type        = bool
  default     = true
  description = "Whether or not to enable the entire module or not."
}

# Transit Gateway
variable "vpn_ecmp_support" {
  type        = string
  default     = "enable"
  description = "Whether VPN Equal Cost Multipath Protocol support is enabled. Valid values: disable, enable. Default value: enable."
}

variable "amazon_side_asn" {
  type        = number
  default     = 64512
  description = "Private Autonomous System Number (ASN) for the Amazon side of a BGP session. The range is 64512 to 65534 for 16-bit ASNs and 4200000000 to 4294967294 for 32-bit ASNs. Default value: 64512."
}

variable "default_route_table_association" {
  type        = string
  default     = "enable"
  description = "Whether resource attachments are automatically associated with the default association route table. Valid values: disable, enable. Default value: enable."
}

variable "auto_accept_shared_attachments" {
  type        = string
  default     = "disable"
  description = "Whether resource attachment requests are automatically accepted. Valid values: disable, enable. Default value: disable."
}

variable "default_route_table_propagation" {
  type        = string
  default     = "enable"
  description = "Whether resource attachments automatically propagate routes to the default propagation route table. Valid values: disable, enable. Default value: enable."
}

variable "description" {
  type        = string
  default     = ""
  description = "Description of the EC2 Transit Gateway"
}

variable "tgw_create" {
  type        = bool
  default     = false
  description = "Whether or not to create a Transit Gateway."
}

# Resource Share
variable "resource_share_account_ids" {
  type        = list(string)
  default     = []
  description = "Ids of the account where the Transit Gateway should be shared."
}

variable "resource_share_allow_external_principals" {
  type        = bool
  default     = false
  description = "Whether or not to allow external principals for the Resource Share for the Transit Gateway."
}

variable "resource_share_enable" {
  type        = bool
  default     = false
  description = "Whether or not to create a Resource Share for the Transit Gateway."
}

variable "transit_gateway_id" {
  type        = string
  default     = null
  description = "The ID of gateway id."
}

variable "resource_share_arn" {
  type        = string
  default     = ""
  description = "ARN of RAM."
}

variable "aws_ram_resource_share_accepter" {
  type        = bool
  default     = false
  description = "Accepter the RAM."
}

variable "transit_gateway_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "One or more IPv4 or IPv6 CIDR blocks for the transit gateway. Must be a size /24 CIDR block or larger for IPv4, or a size /64 CIDR block or larger for IPv6"
}

variable "dns_support" {
  type        = string
  default     = "enable"
  description = "Should be true to enable DNS support in the TGW"
}

variable "multicast_support" {
  type        = string
  default     = "enable"
  description = "Whether multicast support is enabled"
}

variable "vpc_attachments" {
  description = "Maps of maps of VPC details to attach to TGW. Type 'any' to disable type validation by Terraform."
  type        = any
  default     = {}
}

variable "hub_static_route" {
  type        = bool
  default     = false
  description = "This variable use in create a transit gateway static route"
}
