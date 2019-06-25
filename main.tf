# todo
# include a few more shortcuts. i.e. vpc cidr ingress and egress and a list of ports, common services

resource "aws_security_group" "security_group" {
  description = var.description
  name        = var.name
  vpc_id      = var.vpc_id
  tags        = merge(map("Name", var.name), var.tags)
}

resource "aws_security_group_rule" "toggle_self_allow_all_ingress" {
  count             = var.toggle_self_allow_all_ingress ? 1 : 0

  description       = "self ingress all protocols"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.security_group.id
  self              = "true"
  type              = "ingress"
}

resource "aws_security_group_rule"  "toggle_self_allow_all_egress" {
  count             = var.toggle_self_allow_all_egress ? 1 : 0

  description       = "self egress all protocols"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.security_group.id
  self              = "true"
  type              = "egress"
}

resource "aws_security_group_rule" "toggle_allow_all_ingress" {
  count             = var.toggle_allow_all_ingress ? 1 : 0

  description       = "ingress allow all protocols and ports to all"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.security_group.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "toggle_allow_all_egress" {
  count             = var.toggle_allow_all_egress ? 1 : 0

  description       = "egress allow all protocols and ports to all"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.security_group.id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}


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
