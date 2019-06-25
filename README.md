# tf_module_aws_security_group
This module creates an aws security group and any needed security group rules. Its goal is to genericize security groups rule combinations and to limit hard coding rules in tf modules.
This module provides:

* toggle switch for ingress all protocols and ports from self
* toggle switch for ingress all protocols from the internet (for development use)
* toggle switch for egress all protocols and ports to self
* toggle switch for egress all protocols and ports to the internet
* create ingress source cidr based rules from an input list of maps
* create ingress source sg based rules from an input list of maps
* create ingress source self sg based rules from an input list of maps
* create egress cidr based rules from ain input list of maps.
* create egress sg based rules from an input list of maps
* create egress to self sg based rules from an input list of maps

## Terraform version

* v0.12

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| description | the security group description | `string` | n/a | yes |
| egress\_cidr\_rules | a list of egress cidr rule maps | `list(map(string))` | `[]` | no |
| egress\_security\_group\_rules | a list of egress security group id rule maps | `list(map(string))` | `[]` | no |
| egress\_self\_security\_group\_rules | a list of egress rules for the security group to itself | `list` | `[]` | no |
| ingress\_cidr\_rules | a list of egress cidr rule maps | `list(map(string))` | `[]` | no |
| ingress\_security\_group\_rules | a list of ingress security group rule maps | `list(map(string))` | `[]` | no |
| ingress\_self\_security\_group\_rules | a list of ingress rules for the security group to itself | `list(map(string))` | `[]` | no |
| name | the security group name | `string` | n/a | yes |
| tags | A map of tags applied to the security group | `map(string)` | `{}` | no |
| toggle\_allow\_all\_egress | helper toggle to allow all egress traffic. | `string` | `"0"` | no |
| toggle\_allow\_all\_ingress | helper toggle to allow all ingress traffic | `string` | `"0"` | no |
| toggle\_self\_allow\_all\_egress | helper toggle to allow all egress traffic to self | `string` | `"0"` | no |
| toggle\_self\_allow\_all\_ingress | helper toggle to allow all ingress traffic to self | `string` | `"0"` | no |
| vpc\_id | the default security group id | `string` | n/a | yes |

## Outputs

| Name | Description | Type |
|------|-------------|:------:|
| security\_group\_id | the aws security group id | `string`


## Usage
```
variable "name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "vpc_id" {
  type = string
}


data "aws_vpc" "vpc" {
  id = var.vpc_id
}

locals {
  self_security_group_rules = [
    { desc = "etcd client ",  from_port = "2379", to_port = "2379", protocol = "tcp"},
    { desc = "etcd peer",  from_port = "2380", to_port = "2380", protocol = "tcp"},
    { desc = "apiserver",  from_port = "6443", to_port = "6443", protocol = "tcp"},
    { desc = "flannel/canal",  from_port = "8472", to_port = "8472", protocol = "udp"},
    { desc = "kubelet",  from_port = "10250", to_port = "10250", protocol = "tcp"},
    { desc = "prometheus-kube-scheduler",  from_port = "10251", to_port = "10251", protocol = "tcp"},
    { desc = "prometheus-kube-controller-manager",  from_port = "10252", to_port = "10252", protocol = "tcp"},
    { desc = "prometheus-node-exporter",  from_port = "9100", to_port = "9100", protocol = "tcp"},
    { desc = "node port range",  from_port = "30000", to_port = "32767", protocol = "tcp"},
    { desc = "node port range",  from_port = "30000", to_port = "32767", protocol = "udp"},
  ]
  ingress_cidr_rules = [
    { desc = "vpc apiserver nlb health checks",  from_port = "6443", to_port = "6443", protocol = "tcp", cidr_blocks = data.aws_vpc.vpc.cidr_block },
    { desc = "pretend mgmt ssh",  from_port = "22", to_port = "22", protocol = "tcp", cidr_blocks = data.aws_vpc.vpc.cidr_block },
  ]
}

module "sg" {
  source = "../"

  description                   = format("%s security group", var.name)
  egress_cidr_rules             = []
  egress_security_group_rules   = []
  ingress_self_security_group_rules = local.self_security_group_rules
  ingress_cidr_rules            = local.ingress_cidr_rules
  ingress_security_group_rules  = []
  name                          = var.name
  tags                          = var.tags
  toggle_allow_all_egress       = "0"
  toggle_allow_all_ingress      = "0"
  toggle_self_allow_all_egress  = "0"
  toggle_self_allow_all_ingress = "0"
  vpc_id                        = var.vpc_id
}
```
