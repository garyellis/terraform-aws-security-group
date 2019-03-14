# tf_module_aws_security_group
This module creates an aws security group and any needed security group rules. Its goal is to genericize security groups rule combinations and to limit hard coding rules in tf modules.
This module supports the following functionality::

* toggle switch for ingress all protocols and ports from self
* toggle switch for ingress all protocols from the internet (for development use)
* toggle switch for egress all protocols and ports to self
* toggle switch for egress all protocols and ports to the internet
* create ingress source sg based rules from an input list of maps
* create ingress source cidr based rules from an input list of maps
* create egress sg based rules from an input list of maps
* create egress cidr based rules from ain input list of maps.


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| description | the security group description | string | n/a | yes |
| egress\_cidr\_rules | a list of egress cidr rule maps | list | `<list>` | no |
| egress\_security\_group\_rules | a list of egress security group id rule maps | list | `<list>` | no |
| egress\_self\_security\_group\_rules | a list of egress rules for the security group to itself | list | `<list>` | no |
| ingress\_cidr\_rules | a list of egress cidr rule maps | list | `<list>` | no |
| ingress\_security\_group\_rules | a list of ingress security group rule maps | list | `<list>` | no |
| ingress\_self\_security\_group\_rules | a list of ingress rules for the security group to itself | list | `<list>` | no |
| name | the security group name | string | n/a | yes |
| tags | A map of tags applied to the security group | map | `<map>` | no |
| toggle\_allow\_all\_egress | helper toggle to allow all egress traffic. | string | `"0"` | no |
| toggle\_allow\_all\_ingress | helper toggle to allow all ingress traffic. for development only | string | `"0"` | no |
| toggle\_self\_allow\_all\_egress | helper toggle to allow all egress traffic to self | string | `"0"` | no |
| toggle\_self\_allow\_all\_ingress | helper toggle to allow all ingress traffic to self | string | `"0"` | no |
| vpc\_id | the default security group id | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| security\_group\_id |  |


## Usage
```
locals {
  name                = "foo"
  vpc_id              = "vpc-fetchedfromsomeplace"

  # setup our map of tags
  tags                = {
    environment_name = "gellis"
    environment_stage = "dev"
    owner = "myteam"
    project = "someprojectname"
    myfootag = "foo"
  }

  control_plane_sg_id = "sg-fetchedfromsomeplace"

  # ingress configuration
  ingress_cidr_rules = [
    { desc = "ssh from management", from_port = "22", to_port = "22", protocol = "tcp", cidr_blocks = "10.10.10.10/24" },
  ]
  ingress_security_group_rules = [
    { desc = "ingress control plane to etcd",  from_port = "2379", to_port = "2379", protocol = "tcp", source_security_group_id = "${var.control_plane_sg}" },
  ]

  ingress_self_security_group_rules = [
    { desc = "etcd client ",  from_port = "2379", to_port = "2379", protocol = "tcp"},
    { desc = "etcd peer",  from_port = "2380", to_port = "2380", protocol = "tcp"},
  ]

  # egress configuration
  egress_self_security_group_rules = [
    { desc = "etcd client ",  from_port = "2379", to_port = "2379", protocol = "tcp"},
    { desc = "etcd peer",  from_port = "2380", to_port = "2380", protocol = "tcp"},
  ]
}

module "sg" {
  source = "github.com/garyellis/tf_module_aws_security_group"

  description = "my security group"
  egress_cidr_rules = []
  egress_security_group_rules = []
  egress_self_security_group_rules = ["${local.egress_self_security_group_rules}"]
  ingress_cidr_rules = ["${local.ingress_cidr_rules}"]
  ingress_security_group_rules = ["${local.ingress_security_group_rules}"]
  ingress_self_security_group_rules = ["${local.ingress_security_group_rules}"]
  name                          = "${local.name}"
  tags                          = "${local.tags}"
  toggle_allow_all_egress       = "0"
  toggle_allow_all_ingress      = "0"
  toggle_self_allow_all_egress  = "0"
  toggle_self_allow_all_ingress = "0"
  vpc_id = "${local.vpc_id}"
}

```
