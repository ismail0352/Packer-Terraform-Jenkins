# Setting Up Windows Slave 
data "aws_ami" "jenkins_worker_windows" {
  most_recent      = true
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["windows-slave-for-jenkins*"]
  }
}

resource "aws_key_pair" "jenkins_worker_windows" {
  key_name   = "jenkins_worker_windows"
  public_key = "${file("jenkins_worker.pub")}"
}

data "template_file" "userdata_jenkins_worker_windows" {
  template = "${file("scripts/jenkins_worker_windows.ps1")}"

  vars {
    env         = "dev"
    region      = "us-east-1"
    datacenter  = "dev-us-east-1"
    node_name   = "us-east-1-jenkins_worker_windows"
    domain      = ""
    device_name = "eth0"
    server_ip   = "${aws_instance.jenkins_server.private_ip}"
    worker_pem  = "${data.local_file.jenkins_worker_pem.content}"
    jenkins_username = "admin"
    jenkins_password = "mysupersecretpassword"
  }
}

# lookup the security group of the Jenkins Server
data "aws_security_group" "jenkins_worker_windows" {
  filter {
    name   = "group-name"
    values = ["dev_jenkins_worker_windows"]
  }
}

resource "aws_launch_configuration" "jenkins_worker_windows" {
  name_prefix                 = "dev-jenkins-worker-"
  image_id                    = "${data.aws_ami.jenkins_worker_windows.image_id}"
  instance_type               = "t3.medium"
  iam_instance_profile        = "dev_jenkins_worker_windows"
  key_name                    = "${aws_key_pair.jenkins_worker_windows.key_name}"
  security_groups             = ["${data.aws_security_group.jenkins_worker_windows.id}"]
  user_data                   = "${data.template_file.userdata_jenkins_worker_windows.rendered}"
  associate_public_ip_address = false

  root_block_device {
    delete_on_termination = true
    volume_size = 100
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "jenkins_worker_windows" {
  name                      = "dev-jenkins-worker-windows"
  min_size                  = "1"
  max_size                  = "2"
  desired_capacity          = "2"
  health_check_grace_period = 60
  health_check_type         = "EC2"
  vpc_zone_identifier       = ["${data.aws_subnet_ids.default_public.ids}"]
  launch_configuration      = "${aws_launch_configuration.jenkins_worker_windows.name}"
  termination_policies      = ["OldestLaunchConfiguration"]
  wait_for_capacity_timeout = "10m"
  default_cooldown          = 60

  #lifecycle {
  #  create_before_destroy = true
  #}


  ## on replacement, gives new service time to spin up before moving on to destroy
  #provisioner "local-exec" {
  #  command = "sleep 60"
  #}

  tags = [
    {
      key                 = "Name"
      value               = "dev_jenkins_worker_windows"
      propagate_at_launch = true
    },
    {
      key                 = "class"
      value               = "dev_jenkins_worker_windows"
      propagate_at_launch = true
    },
  ]
}
