##########################################################
# Variables
##########################################################

##  Declare the variables here.

variable "vpc-name" {
  description = "Name for VPC"
  default     = ""
}

variable "stack-name" {
  description = "Name for stack (dev/prod etc)"
  default     = ""
}

variable "cidr-block" {
   description = "Base CIDR"
   default = ""
}


variable "ip-base-value" {
  description = "lowest IP address value for this VPC"
  default     = ""
}


variable "key-filename" {
    description = "filename of the server key file"
	default = ""
}

variable "elb-log-bucket" {
    description = "Name of the bucket used to store elb logs"
	 default = ""
} 


variable "min-instances" {
    description = "The minimum number of application server instances"
    default = 1
}

variable "max-instances" {
    description = "The maximum number of application server instances"
    default = 2
}


variable "region"     { 
  description = "AWS region to host your network"
  default     = "eu-west-1" 
}

variable "zones" {
  type = "list"
  default = [ "eu-west-1a", "eu-west-1b"]
} 

