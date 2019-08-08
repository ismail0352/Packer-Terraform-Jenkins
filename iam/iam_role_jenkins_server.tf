resource "aws_iam_instance_profile" "jenkins_server" {
  name = "jenkins_server"
  role = "${aws_iam_role.jenkins_server.name}"
}

resource "aws_iam_role" "jenkins_server" {
  name = "jenkins_server"
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