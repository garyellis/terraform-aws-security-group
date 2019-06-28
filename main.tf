# todo
# add more security group rule helper shortcuts. i.e. more common services, vpc cidr ports list, subnet cidr ports list
data "aws_vpc" "current" {
  id = var.vpc_id
}

resource "aws_security_group" "security_group" {
  description = var.description
  name        = var.name
  vpc_id      = var.vpc_id
  tags        = merge(map("Name", var.name), var.tags)
}

# security group all self helper rules
resource "aws_security_group_rule" "toggle_self_allow_all_ingress" {
  count             = var.toggle_self_allow_all_ingress ? 1 : 0

  description       = "self ingress all ports and protocols"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.security_group.id
  self              = "true"
  type              = "ingress"
}

resource "aws_security_group_rule"  "toggle_self_allow_all_egress" {
  count             = var.toggle_self_allow_all_egress ? 1 : 0

  description       = "self egress all ports and protocols"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.security_group.id
  self              = "true"
  type              = "egress"
}

# all traffic helper rules
resource "aws_security_group_rule" "toggle_allow_all_ingress" {
  count             = var.toggle_allow_all_ingress ? 1 : 0

  description       = "ingress allow all ports and protocols from all"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.security_group.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "toggle_allow_all_egress" {
  count             = var.toggle_allow_all_egress ? 1 : 0

  description       = "egress allow all ports and protocols and ports to all"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.security_group.id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}

# vpc all traffic helper rules
resource "aws_security_group_rule" "toggle_allow_all_vpc_cidr_ingress" {
  count = var.toggle_allow_vpc_cidr_all_ingress ? 1 : 0

  description       = "ingress allow all ports and protocols from the vpc cidr"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  type              = "ingress"
  security_group_id = aws_security_group.security_group.id
  cidr_blocks       = [data.aws_vpc.current.cidr_block]
}

resource "aws_security_group_rule" "toggle_allow_all_vpc_cidr_egress" {
  count = var.toggle_allow_vpc_cidr_all_egress ? 1 : 0

  description       = "egress allow all ports and protocols to the vpc cidr"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.security_group.id
  type              = "egress"
  cidr_blocks       = [data.aws_vpc.current.cidr_block]
}

# vpc https helper rules
resource "aws_security_group_rule" "toggle_allow_https_vpc_cidr_ingress" {
  count = var.toggle_allow_vpc_https_ingress ? 1 : 0

  description       = "egress allow https from the vpc cidr"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.security_group.id
  type              = "ingress"
  cidr_blocks       = [data.aws_vpc.current.cidr_block]

}

resource "aws_security_group_rule" "toggle_allow_https_vpc_cidr_egress" {
  count = var.toggle_allow_vpc_https_egress ? 1 : 0

  description       = "egress allow https to vpc cidr"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.security_group.id
  type              = "egress"
  cidr_blocks       = [data.aws_vpc.current.cidr_block]
}

# vpc http helper rules
resource "aws_security_group_rule" "toggle_allow_http_vpc_cidr_ingress" {
  count = var.toggle_allow_vpc_http_ingress ? 1 : 0

  description       = "egress allow http from the vpc cidr"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.security_group.id
  type              = "ingress"
  cidr_blocks       = [data.aws_vpc.current.cidr_block]

}

resource "aws_security_group_rule" "toggle_allow_http_vpc_cidr_egress" {
  count = var.toggle_allow_vpc_http_egress ? 1 : 0

  description       = "egress allow http to the vpc cidr"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.security_group.id
  type              = "egress"
  cidr_blocks       = [data.aws_vpc.current.cidr_block]
}


# user defined rules
resource "aws_security_group_rule" "ingress_self_security_group" {
  count                    = length(var.ingress_self_security_group_rules)

  description              = lookup(var.ingress_self_security_group_rules[count.index], "desc")
  type                     = "ingress"
  from_port                = lookup(var.ingress_self_security_group_rules[count.index], "from_port")
  to_port                  = lookup(var.ingress_self_security_group_rules[count.index], "to_port")
  protocol                 = lookup(var.ingress_self_security_group_rules[count.index], "protocol")
  security_group_id        = aws_security_group.security_group.id
  self                     = "true"
}

resource "aws_security_group_rule" "egress_self_security_group" {
  count                    = length(var.egress_self_security_group_rules)

  description              = lookup(var.egress_self_security_group_rules[count.index], "desc")
  type                     = "ingress"
  from_port                = lookup(var.egress_self_security_group_rules[count.index], "from_port")
  to_port                  = lookup(var.egress_self_security_group_rules[count.index], "to_port")
  protocol                 = lookup(var.egress_self_security_group_rules[count.index], "protocol")
  security_group_id        = aws_security_group.security_group.id
  self                     = "true"
}

resource "aws_security_group_rule" "ingress_security_groups" {
  count                    = length(var.ingress_security_group_rules)

  description              = lookup(var.ingress_security_group_rules[count.index], "desc")
  type                     = "ingress"
  from_port                = lookup(var.ingress_security_group_rules[count.index], "from_port")
  to_port                  = lookup(var.ingress_security_group_rules[count.index], "to_port")
  protocol                 = lookup(var.ingress_security_group_rules[count.index], "protocol")
  security_group_id        = aws_security_group.security_group.id
  source_security_group_id = lookup(var.ingress_security_group_rules[count.index], "source_security_group_id")
}

resource "aws_security_group_rule" "egress_security_groups" {
  count                    = length(var.egress_security_group_rules)

  description              = lookup(var.egress_security_group_rules[count.index], "desc")
  type                     = "egress"
  from_port                = lookup(var.egress_security_group_rules[count.index], "from_port")
  to_port                  = lookup(var.egress_security_group_rules[count.index], "to_port")
  protocol                 = lookup(var.egress_security_group_rules[count.index], "protocol")
  security_group_id        = aws_security_group.security_group.id
  source_security_group_id = lookup(var.egress_security_group_rules[count.index], "source_security_group_id")
}

resource "aws_security_group_rule" "ingress_cidrs" {
  count                    = length(var.ingress_cidr_rules)

  description              = lookup(var.ingress_cidr_rules[count.index], "desc")
  type                     = "ingress"
  from_port                = lookup(var.ingress_cidr_rules[count.index], "from_port")
  to_port                  = lookup(var.ingress_cidr_rules[count.index], "to_port")
  protocol                 = lookup(var.ingress_cidr_rules[count.index], "protocol")
  cidr_blocks              = split(",",lookup(var.ingress_cidr_rules[count.index], "cidr_blocks"))
  security_group_id        = aws_security_group.security_group.id
}

resource "aws_security_group_rule" "egress_cidrs" {
  count                    = length(var.egress_cidr_rules)

  description              = lookup(var.egress_cidr_rules[count.index], "desc")
  type                     = "egress"
  from_port                = lookup(var.egress_cidr_rules[count.index], "from_port")
  to_port                  = lookup(var.egress_cidr_rules[count.index], "to_port")
  protocol                 = lookup(var.egress_cidr_rules[count.index], "protocol")
  cidr_blocks              = split(",",lookup(var.egress_cidr_rules[count.index], "cidr_blocks"))
  security_group_id        = aws_security_group.security_group.id
}
