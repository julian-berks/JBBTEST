##########################################################
# Load Balancers
# Create Load-Balancer and associated components 
##########################################################

data "aws_caller_identity" "current" { }

data "template_file" "elb-log-bucket-policy"
{ 
      template = "${file("../Go-App/elb_log_bucket_policy.json")}"

   vars {
        elb_s3_bucket = "${format("%s%s%s%s%s", "arn:aws:s3:::", "${var.elb-log-bucket}", "/log/AWSLogs/", "${data.aws_caller_identity.current.account_id}", "/*")}"
        }
}



# external Load Balancer
resource "aws_elb" "load_balancer" {
  name = "${var.stack-name}-ext-load-balancer"
  subnets = ["${aws_subnet.dmz_subnet.*.id}"]
  security_groups = ["${aws_security_group.elb.id}"]
 
  access_logs {
    bucket = "${var.elb-log-bucket}"
    bucket_prefix = "log"
    interval = 5
  }


listener {
    instance_port = 8484
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 5
    target = "HTTP:8484/"
    interval = 30
  }

  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400

  tags {
    Name = "Load-Balancer"
  }
  depends_on = ["aws_s3_bucket.elb_log_bucket"]
}


output "application-url" {
   value = "${aws_elb.load_balancer.dns_name}"
   }

