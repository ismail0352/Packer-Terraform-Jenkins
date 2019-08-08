resource "aws_iam_instance_profile" "dev_jenkins_worker_windows" {
  name = "dev_jenkins_worker_windows"
  role = "${aws_iam_role.dev_jenkins_worker_windows.name}"
}

resource "aws_iam_role" "dev_jenkins_worker_windows" {
  name = "dev_jenkins_worker_windows"
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
