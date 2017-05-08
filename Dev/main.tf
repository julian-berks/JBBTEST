module "Dev" {
  source = "../Network"
  vpc-name  = "Dev-VPC"
  cidr-block = "172.31.0.0/16"
  ip-base-value = "12"
  elb-log-bucket = "devcaptest-elb-bucket"
  key-filename = "keyfile.pub"
  min-instances = 2
  max-instances = 2
}


output "application-url" {
   value = "${module.Dev.application-url}"
   }

