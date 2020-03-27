#Module      : LABEL
#Description : Terraform label module variables.
variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "application" {
  type        = string
  default     = ""
  description = "Application (e.g. `cd` or `clouddrove`)."
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "label_order" {
  type        = list
  default     = []
  description = "Label order, e.g. `name`,`application`."
}

variable "attributes" {
  type        = list
  default     = []
  description = "Additional attributes (e.g. `1`)."
}

variable "tags" {
  type        = map
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)."
}

variable "managedby" {
  type        = string
  default     = "anmol@clouddrove.com"
  description = "ManagedBy, eg 'CloudDrove' or 'AnmolNagpal'."
}

variable "enable" {
  description = "Whether or not to enable the entire module or not."
  default     = true
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

variable "vpc_attachement_create" {
  type        = bool
  default     = false
  description = "Whether or not to create the Transit Gateway VPC attachment."
}

variable "subnet_ids" {
  type        = list
  default     = []
  description = "Subnets to attached to the Transit Gateway. These subnets will be used internally by AWS to install the Transit Gateway."
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "Identifier of EC2 VPC."
}

variable "transit_gateway_default_route_table_association" {
  type        = bool
  default     = true
  description = "Boolean whether the VPC Attachment should be associated with the EC2 Transit Gateway association default route table. This cannot be configured or perform drift detection with Resource Access Manager shared EC2 Transit Gateways. Default value: true."
}

variable "transit_gateway_default_route_table_propagation" {
  type        = bool
  default     = true
  description = "Boolean whether the VPC Attachment should propagate routes with the EC2 Transit Gateway propagation default route table. This cannot be configured or perform drift detection with Resource Access Manager shared EC2 Transit Gateways. Default value: true."
}

# Resource Share
variable "resource_share_account_ids" {
  type        = list
  default     = []
  description = "Ids of the account where the Transit Gateway should be shared."
}

variable "resource_share_allow_external_principals" {
  type        = bool
  default     = true
  description = "Whether or not to allow external principals for the Resource Share for the Transit Gateway."
}

variable "resource_share_enable" {
  type        = bool
  default     = false
  description = "Whether or not to create a Resource Share for the Transit Gateway."
}

variable "destination_cidr_block" {
  type        = list
  default     = []
  description = "The destination CIDR block."
}

variable "use_existing_transit_gateway_id" {
  type        = bool
  default     = false
  description = "if use existing gateway id."
}

variable "transit_gateway_id" {
  type        = string
  default     = ""
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
