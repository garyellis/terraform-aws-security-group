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
