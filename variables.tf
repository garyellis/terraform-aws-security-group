variable "description" {
  description = "the security group description"
}

variable "egress_cidr_rules" {
  description = "a list of egress cidr rule maps"
  default = []
  type = "list"
}

variable "egress_security_group_rules" {
  description = "a list of egress security group id rule maps"
  default = []
  type = "list"
}

variable "egress_self_security_group_rules" {
  description = "a list of egress rules for the security group to itself"
  default = []
  type = "list" 
}

variable "ingress_cidr_rules" {
  description = "a list of egress cidr rule maps"
  default = []
  type = "list"
}

variable "ingress_security_group_rules" {
  description = "a list of ingress security group rule maps"
  default = []
  type = "list"
}

variable "ingress_self_security_group_rules" {
  description = "a list of ingress rules for the security group to itself"
  default = []
  type = "list"
}

variable "name" {
  description = "the security group name"
}

variable "tags" {
  description = "A map of tags applied to the security group"
  default = {}
  type = "map"
}

variable "toggle_self_allow_all_egress" {
  description = "helper toggle to allow all egress traffic to self"
  default     = "0"
  type        = "string"
}

variable "toggle_self_allow_all_ingress" {
  description = "helper toggle to allow all ingress traffic to self"
  default     = "0"
  type        = "string"
}

variable "toggle_allow_all_ingress" {
  description = "helper toggle to allow all ingress traffic"
  default     = "0"
  type        = "string"
}

variable "toggle_allow_all_egress" {
  description = "helper toggle to allow all egress traffic."
  default     = "0"
  type        = "string"
}

variable "vpc_id" {
  description = "the default security group id"
}
