module "Dev" {
  source = "../Go-App"
  vpc-name  = "Dev-VPC"
  stack-name = "dev"
  cidr-block = "172.31.0.0/16"
  ip-base-value = "12"
  elb-log-bucket = "devcaptest-elb-bucket"
  key-filename = "keyfile.pub"
  min-instances = 2
  max-instances = 2
  region = "eu-west-1"
  zones = [ "eu-west-1a", "eu-west-1b"]
}

terraform {
  backend "s3" {
    bucket = "captest-terraform"
    key    = "/dev"
    region = "eu-west-1"
  }
}


output "application-url" {
   value = "${module.Dev.application-url}"
   }

