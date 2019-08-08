resource "aws_iam_instance_profile" "dev_jenkins_worker_linux" {
  name = "dev_jenkins_worker_linux"
  role = "${aws_iam_role.dev_jenkins_worker_linux.name}"
}

resource "aws_iam_role" "dev_jenkins_worker_linux" {
  name = "dev_jenkins_worker_linux"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}