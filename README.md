# tf_module_aws_security_group
This module creates an aws security group and rules. It aims to manage security groups rule combinations consistently.
The following resources and configuration are provided:

* create an aws security group or work on an existing security group id
* ingress source cidr based rules inputs
* ingress source sg based rules inputs 
* self sg rules input
* egress cidr based rules input
* egress sg based rules input
* toggle switch for ingress all protocols and ports from self
* toggle switch for ingress all protocols from the internet (i.e. for debugging)
* toggle switch for egress all protocols and ports to self
* toggle switch for egress all protocols and ports to the internet (i.e. for debugging)
* toggle switch for ingress all protocols from the current vpc cidr
* toggle switch for egress all protocols to the current vpc cidr
* toggle switch for ingress http from the current vpc cidr
* toggle switch for egress to the current vpc cidr
* toggle switch for ingress https from the current vpc cidr
* toggle switch for egress https to the current vpc cidr

## Terraform version

* v0.12

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create\_security\_group | create the security group. set to false when working on an existing security group | `bool` | `true` | no |
| description | the security group description | `string` | "" | yes when creating security group |
| security\_group\_id | apply rules on an existing security group id | `string` | "" | no |
| self\_security\_group\_rules | a list of rules for the security group to itself | `list(map(string))` | `[]` | no |
| egress\_cidr\_rules | a list of egress cidr rule maps | `list(map(string))` | `[]` | no |
| egress\_security\_group\_rules | a list of egress security group id rule maps | `list(map(string))` | `[]` | no |
| ingress\_cidr\_rules | a list of egress cidr rule maps | `list(map(string))` | `[]` | no |
| ingress\_security\_group\_rules | a list of ingress security group rule maps | `list(map(string))` | `[]` | no |
| name | the security group name | `string` | n/a | yes when creating security group |
| tags | a map of tags applied to the security group | `map(string)` | `{}` | no |
| toggle\_allow\_all\_egress | helper toggle to allow all egress traffic. | `bool` | `false` | no |
| toggle\_allow\_all\_ingress | helper toggle to allow all ingress traffic | `bool` | `false` | no |
| toggle\_self\_allow\_all\_egress | helper toggle to allow all egress traffic to self | `bool` | `false` | no |
| toggle\_self\_allow\_all\_ingress | helper toggle to allow all ingress traffic to self | `bool` | `false` | no |
| toggle\_allow\_vpc\_cidr\_all\_ingress | helper toggle to allow all egress ports/protocls to the current vpc cidr | `bool` | `false` | no |
| toggle\_allow\_vpc\_cidr\_all_egress | helper toggle to allow all egress ports/protocols to the current vpc cidr | `bool` | `false` | no |
| toggle\_allow\_vpc\_https\_ingress | helper toggle to allow https ingress from the current vpc cidr | `bool` | `false` | no |
| toggle\_allow\_vpc\_https\_egress | helper toggle to allow https egress to the current vpc cidr | `bool` | `false` | no |
| toggle\_allow\_vpc\_http\_ingress | helper toggle to allow http egress to the current vpc cidr | `bool` | `false` | no |
| toggle\_allow\_vpc\_http\_egress | helper toggle to allow http egress to the current vpc cidr | `bool` | `false` | no |
| vpc\_id | the current vpc id | `string` | n/a | yes |

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
  source = "github.com/garyellis/tf_module_aws_security_group"

  description                       = format("%s security group", var.name)
  egress_cidr_rules                 = []
  egress_security_group_rules       = []
  self_security_group_rules         = local.self_security_group_rules
  ingress_cidr_rules                = local.ingress_cidr_rules
  ingress_security_group_rules      = []
  name                              = var.name
  tags                              = var.tags
  toggle_allow_all_egress           = true
  toggle_allow_all_ingress          = true
  toggle_self_allow_all_egress      = false
  toggle_self_allow_all_ingress     = false
  toggle_allow_vpc_cidr_all_ingress = true
  toggle_allow_vpc_cidr_all_egress  = true
  toggle_allow_vpc_https_ingress    = true
  toggle_allow_vpc_https_egress     = true
  toggle_allow_vpc_http_ingress     = true
  toggle_allow_vpc_http_egress      = true

  vpc_id                            = var.vpc_id
}
```
