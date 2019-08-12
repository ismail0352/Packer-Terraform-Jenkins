resource "aws_security_group" "dev_jenkins_worker_linux" {
  name        = "dev_jenkins_worker_linux"
  description = "Jenkins Server: created by Terraform for [dev]"

# legacy name of VPC ID
  vpc_id = "${data.aws_vpc.default_vpc.id}"

  tags {
    Name = "dev_jenkins_worker_linux"
    env  = "dev"
  }
}

###############################################################################
# ALL INBOUND
###############################################################################

# ssh
resource "aws_security_group_rule" "jenkins_worker_linux_from_source_ingress_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = "${aws_security_group.dev_jenkins_worker_linux.id}"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "ssh to jenkins_worker_linux"
}

# ssh
resource "aws_security_group_rule" "jenkins_worker_linux_from_source_ingress_webui" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  security_group_id = "${aws_security_group.dev_jenkins_worker_linux.id}"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "ssh to jenkins_worker_linux"
}


###############################################################################
# ALL OUTBOUND
###############################################################################

resource "aws_security_group_rule" "jenkins_worker_linux_to_all_80" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = "${aws_security_group.dev_jenkins_worker_linux.id}"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "allow jenkins worker to all 80"
}

resource "aws_security_group_rule" "jenkins_worker_linux_to_all_443" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.dev_jenkins_worker_linux.id}"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "allow jenkins worker to all 443"
}

resource "aws_security_group_rule" "jenkins_worker_linux_to_other_machines_ssh" {
  type              = "egress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = "${aws_security_group.dev_jenkins_worker_linux.id}"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "allow jenkins worker linux to jenkins server"
}

resource "aws_security_group_rule" "jenkins_worker_linux_to_jenkins_server_8080" {
  type                     = "egress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.dev_jenkins_worker_linux.id}"
  source_security_group_id = "${aws_security_group.jenkins_server.id}"
  description              = "allow jenkins workers linux to jenkins server"
}
