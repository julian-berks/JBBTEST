module "Prod" {
  source = "../Go-App"
  vpc-name  = "Prod-VPC"
  cidr-block = "172.31.0.0/16"
  ip-base-value = "36"
  elb-log-bucket = "prodcaptest-elb-bucket"
  key-filename = "keyfile.pub"
  min-instances = 2
  max-instances = 2
}


output "application-url" {
   value = "${module.Prod.application-url}"
   }

