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

variable "vpc_id" {
  type        = "string"
  description = "VPC ID"
}

variable "subnet_ids" {
  type        = "list"
  default     = []
  description = "List of subnet ids"
}

variable "route_table_id" {
  type        = "string"
  description = "Route table id"
}

variable "destination_cidr_block" {
  type        = "string"
  description = "Base CIDR block which is divided into subnet CIDR blocks (e.g. `10.0.0.0/16`)"
  default     = "null"
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