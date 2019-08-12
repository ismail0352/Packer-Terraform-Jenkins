# Security Group:
resource "aws_security_group" "jenkins_server" {
  name        = "jenkins_server"
  description = "Jenkins Server: created by Terraform for [dev]"

  # legacy name of VPC ID
  vpc_id = "${data.aws_vpc.default_vpc.id}"

  tags {
    Name = "jenkins_server"
    env  = "dev"
  }
}

###############################################################################
# ALL INBOUND
###############################################################################

# ssh
resource "aws_security_group_rule" "jenkins_server_from_source_ingress_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = "${aws_security_group.jenkins_server.id}"
  cidr_blocks       = ["0.0.0.0/16"]
  description       = "ssh to jenkins_server"
}

# web
resource "aws_security_group_rule" "jenkins_server_from_source_ingress_webui" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  security_group_id = "${aws_security_group.jenkins_server.id}"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "jenkins server web"
}

# JNLP
resource "aws_security_group_rule" "jenkins_server_from_source_ingress_jnlp" {
  type              = "ingress"
  from_port         = 33453
  to_port           = 33453
  protocol          = "tcp"
  security_group_id = "${aws_security_group.jenkins_server.id}"
  cidr_blocks       = ["172.31.0.0/16"]
  description       = "jenkins server JNLP Connection"
}

###############################################################################
# ALL OUTBOUND
###############################################################################

resource "aws_security_group_rule" "jenkins_server_to_other_machines_ssh" {
  type              = "egress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = "${aws_security_group.jenkins_server.id}"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "allow jenkins servers to ssh to other machines"
}

resource "aws_security_group_rule" "jenkins_server_outbound_all_80" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = "${aws_security_group.jenkins_server.id}"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "allow jenkins servers for outbound yum"
}

resource "aws_security_group_rule" "jenkins_server_outbound_all_443" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.jenkins_server.id}"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "allow jenkins servers for outbound yum"
}
