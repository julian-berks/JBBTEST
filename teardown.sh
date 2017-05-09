#!/bin/bash
stack=$1

if [ -z "$stack" ]
 then
   echo usage :
   echo "teardown.sh <Environment>"
   exit 1
   elif [ ! -d "$stack" ]
   then
     echo $stack not found
     exit 1
fi


cd $stack

# Terraform creates the ELB Log bucket but cannot delete it if the bucket contains logs
# Clearing it down is unsufficient as the ELB may still write to it during the destroy process.
# Terraform is tolerant of missing items during a destroy so drop the bucket before processing.
# Clear it down before running the destroy command.
bucket=$(grep elb-log-bucket main.tf|cut -d \" -f2)
aws s3 rb s3://$bucket --force
terraform init
terraform destroy

