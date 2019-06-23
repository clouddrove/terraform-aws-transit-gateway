variable "Name" {
  description = "Name  (e.g. `app` or `cluster`)"
  type        = "string"
}

variable "Environment" {
  type        = "string"
  description = "Environment (e.g. `prod`, `dev`, `staging`)"
}

variable "CreatedBy" {
  type        = "string"
  description = "CreatedBy (e.g. `terraform`, `dev`, `devops`)"
}

variable "Organization" {
  type        = "string"
  description = "Organization (e.g. `bac`, `cd`)"
}

variable "default_route_table_association" {
  type    = "string"
  default = ""
}

variable "default_route_table_propagation" {
  type    = "string"
  default = ""
}

variable "auto_accept_shared_attachments" {
  type = "string"
  default = ""
}
