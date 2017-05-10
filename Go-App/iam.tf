########################################################################################################
# EC2 Server Role
########################################################################################################

resource "aws_iam_role" "ec2_server_role" {
     name = "${var.stack-name}-ec2-server-role"
	path = "/"
    assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


# IAM Profile Version
resource "aws_iam_instance_profile" "ec2_server_role" {
    name = "${var.stack-name}-ec2-server-role"
    role = "${aws_iam_role.ec2_server_role.name}"
}


###################
#EC2-Cloudwatch-Logs
# For EC2 Instances to access Cloudwatch.
resource "aws_iam_policy" "ec2_cloudwatchlogs" {
    name = "${var.stack-name}-ec2-cloudwatchlogs"
	path = "/"
    description = "EC2-CloudWatchLogs"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams"
            ],
            "Resource": [
                "arn:aws:logs:*:*:*"
            ]
        }
    ]
}
EOF
}


#Attach the policy to the role
resource "aws_iam_policy_attachment" "ec2-cwl-policy-attach" {
    name = "ec2-cwl-policy-Attach"
    roles = ["${aws_iam_role.ec2_server_role.name}"]
    policy_arn = "${aws_iam_policy.ec2_cloudwatchlogs.arn}" 
}





