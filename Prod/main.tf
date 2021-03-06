module "Prod" {
  source = "../Go-App"
  vpc-name  = "Prod-VPC"
  stack-name = "prod"
  cidr-block = "172.31.0.0/16"
  ip-base-value = "36"
  elb-log-bucket = "prodcaptest-elb-bucket"
  key-filename = "keyfile.pub"
  min-instances = 2
  max-instances = 2
  region = "eu-west-1"
  zones = [ "eu-west-1a", "eu-west-1b"]
}

terraform {
  backend "s3" {
    bucket = "captest-terraform"
    key    = "/prod"
    region = "eu-west-1"
  }
}


output "application-url" {
   value = "${module.Prod.application-url}"
   }

