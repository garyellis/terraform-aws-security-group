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

module "pretend_existing_sg" {
  source = "../"

  description                       = format("%s security group", format("%s-pretend-existing", var.name))
  egress_cidr_rules                 = []
  egress_security_group_rules       = []
  self_security_group_rules         = local.self_security_group_rules
  ingress_cidr_rules                = local.ingress_cidr_rules
  ingress_security_group_rules      = []
  name                              = format("%s-pretend-existing", var.name)
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



# allow traffic to an existing security group
module "sg_to_pretend_existing_sg_egress" {
  source = "../"

  create_security_group       = false
  security_group_id           = module.sg.security_group_id
  egress_security_group_rules = [{ desc = "egress to pretend-existing-sg",  from_port = "443", to_port = "443", protocol = "tcp", source_security_group_id = module.pretend_existing_sg.security_group_id}]
  vpc_id                      = var.vpc_id
}

module "sg_to_pretend_existing_sg_ingress" {
  source = "../"

  create_security_group       = false
  security_group_id           = module.pretend_existing_sg.security_group_id
  ingress_security_group_rules = [{ desc = "ingess from pretend-existing-sg",  from_port = "443", to_port = "443", protocol = "tcp", source_security_group_id = module.sg.security_group_id}]
  vpc_id                      = var.vpc_id
}

output "security_group_rule_ids" {
  value = module.sg.security_group_rule_ids
}
