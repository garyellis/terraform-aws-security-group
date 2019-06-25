variable "description" {
  description = "the security group description"
}

variable "egress_cidr_rules" {
  description = "a list of egress cidr rule maps"
  type = list(map(string))
}

variable "egress_security_group_rules" {
  description = "a list of egress security group id rule maps"
  type = list(map(string))
  default = []
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

variable "ingress_self_security_group_rules" {
  description = "a list of ingress rules for the security group to itself"
  type = list(map(string))
  default = []
}

variable "name" {
  description = "the security group name"
  type = string
}

variable "tags" {
  description = "A map of tags applied to the security group"
  type = map(string)
  default = {}
}

variable "toggle_self_allow_all_egress" {
  description = "helper toggle to allow all egress traffic to self"
  type = string
  default     = "0"
}

variable "toggle_self_allow_all_ingress" {
  description = "helper toggle to allow all ingress traffic to self"
  type = string
  default     = "0"
}

variable "toggle_allow_all_ingress" {
  description = "helper toggle to allow all ingress traffic"
  type = string
  default     = "0"
}

variable "toggle_allow_all_egress" {
  description = "helper toggle to allow all egress traffic."
  type = string
  default     = "0"
}

variable "vpc_id" {
  description = "the default security group id"
  type = string
}
