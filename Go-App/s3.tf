##############################################################
# S3 Buckets
##############################################################

resource "aws_s3_bucket" "elb_log_bucket" {
    bucket = "${var.elb-log-bucket}"
    acl = "private"
	# Add a policy to allow the external AWS ELB process to write to this bucket
	policy = "${data.template_file.elb-log-bucket-policy.rendered}"

    lifecycle_rule {
        id = "log"
        prefix = "log/"
        enabled = true

        transition {
            days = 30
            storage_class = "STANDARD_IA"
        }
        transition {
            days = 60
            storage_class = "GLACIER"
        }
        expiration {
            days = 90
        }
    }
}



