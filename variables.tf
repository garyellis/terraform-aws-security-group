variable "create_security_group" {
  description = "create the security group"
  type = bool
  default = true
}

variable "description" {
  description = "the security group description"
  type = string
  default = ""
}

variable "egress_cidr_rules" {
  description = "a list of egress cidr rule maps"
  type = list(map(string))
  default = []
}

variable "egress_security_group_rules" {
  description = "a list of egress security group id rule maps"
  type = list(map(string))
  default = []
}

variable "egress_prefix_id_rules" {
  description = "a list of vpc gateway endpoint prefix ids"
  type        = list(map(string))
  default     = []
}

variable "egress_self_security_group_rules" {
  description = "a list of egress rules for the security group to itself"
  type = list(map(string))
  default = []
}

variable "ingress_cidr_rules" {
  description = "a list of egress cidr rule maps"
  type = list(map(string))
  default = []
}

variable "ingress_security_group_rules" {
  description = "a list of ingress security group rule maps"
  type = list(map(string))
  default = []
}

variable "self_security_group_rules" {
  description = "a list of rules for the security group to itself"
  type = list(map(string))
  default = []
}

variable "name" {
  description = "the security group name (required when creating security group)"
  type = string
  default = ""
}

variable "tags" {
  description = "A map of tags applied to the security group"
  type = map(string)
  default = {}
}

variable "toggle_self_allow_all_egress" {
  description = "helper toggle to allow all egress traffic to self"
  type = bool
  default = false
}

variable "toggle_self_allow_all_ingress" {
  description = "helper toggle to allow all ingress traffic to self"
  type = bool
  default = false
}

variable "toggle_allow_all_ingress" {
  description = "helper toggle to allow all ingress traffic"
  type = bool
  default = false
}

variable "security_group_id" {
  description = "apply rules on an existing security group id"
  type = string
  default = ""
}

variable "toggle_allow_all_egress" {
  description = "helper toggle to allow all egress traffic."
  type = bool
  default = false
}

variable "toggle_allow_vpc_cidr_all_ingress" {
  description = "helper toggle to allow all egress ports/protocls to the current vpc cidr"
  type = bool
  default = false
}

variable "toggle_allow_vpc_cidr_all_egress" {
  description = "helper toggle to allow all egress ports/protocols to the current vpc cidr"
  type = bool
  default = false
}

variable "toggle_allow_vpc_https_ingress" {
  description = "helper toggle to allow https ingress from the current vpc cidr"
  type = bool
  default = false
}

variable "toggle_allow_vpc_https_egress" {
  description = "helper toggle to allow https egress to the current vpc cidr"
  type = bool
  default = false
}

variable "toggle_allow_vpc_http_ingress" {
  description = "helper toggle to allow http ingress from the current vpc cidr"
  type = bool
  default = false
}

variable "toggle_allow_vpc_http_egress" {
  description = "helper toggle to allow http egress to the current vpc cidr"
  type = bool
  default = false
}

variable "vpc_id" {
  description = "the current vpc id"
  type = string
}
