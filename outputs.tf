output "security_group_id" {
  value = local.security_group_id
}

output "security_group_rule_ids" {
  value = compact(concat(
    aws_security_group_rule.toggle_self_allow_all_ingress.*.id,
    aws_security_group_rule.toggle_self_allow_all_egress.*.id,
    aws_security_group_rule.toggle_allow_all_ingress.*.id,
    aws_security_group_rule.toggle_allow_all_egress.*.id,
    aws_security_group_rule.toggle_allow_all_vpc_cidr_ingress.*.id,
    aws_security_group_rule.toggle_allow_all_vpc_cidr_egress.*.id,
    aws_security_group_rule.toggle_allow_https_vpc_cidr_ingress.*.id,
    aws_security_group_rule.toggle_allow_https_vpc_cidr_egress.*.id,
    aws_security_group_rule.toggle_allow_http_vpc_cidr_ingress.*.id,
    aws_security_group_rule.toggle_allow_http_vpc_cidr_egress.*.id,
    aws_security_group_rule.ingress_self_security_group.*.id,
    aws_security_group_rule.egress_self_security_group.*.id,
    aws_security_group_rule.ingress_security_groups.*.id,
    aws_security_group_rule.egress_security_groups.*.id,
    aws_security_group_rule.egress_prefix_ids.*.id,
    aws_security_group_rule.ingress_cidrs.*.id,
    aws_security_group_rule.egress_cidrs.*.id,
  ))
}
