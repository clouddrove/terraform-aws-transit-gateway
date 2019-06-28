#Module      : LABEL
#Description : Terraform label module variables.
variable "application" {
  type        = "string"
  description = "Application (e.g. `cd` or `clouddrove`)"
}

variable "environment" {
  type        = string
  description = "Environment (e.g. `prod`, `dev`, `staging`)"
}

variable "name" {
  type        = string
  description = "Application or solution name"
}

variable "label_order" {
  type        = list
  default     = []
  description = "label order, e.g. `name`,`application`"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "enabled" {
  description = "Set to false to prevent the module from creating any resources"
  default     = "true"
}

variable "create_tgw" {
  description = "Create a transit gateway or not"
  default     = "true"
}

variable "default_route_table_association" {
  type    = "string"
  default = "enable"
}

variable "default_route_table_propagation" {
  type    = "string"
  default = "enable"
}

variable "auto_accept_shared_attachments" {
  type    = "string"
  default = "enable"
}

variable "dns_support" {
  description = "Whether DNS support is enabled"
  default     = "enable"
}

variable "vpn_ecmp_support" {
  description = "Whether VPN Equal Cost Multipath protocol is enabled"
  default     = "disable"
}
