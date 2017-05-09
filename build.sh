#!/bin/bash
command=$1
stack=$2


if [ -z "$command" ]
 then
   echo usage :
   echo "build.sh <command> <Environment>"
   exit 1
   elif [ $command != "plan" ] && [ $command != "apply" ]
   then
     echo Command should be plan or apply
     echo e.g. build.sh plan Dev
     exit 1
fi

if [ -z "$stack" ]
 then
   echo usage :
   echo "build.sh <command> <Environment>"
   exit 1
   elif [ ! -d "$stack" ]
   then
     echo $stack not found
     exit 1
fi

# Terraform state files will be stored in a local S3 bucket called captest-terraform
# If the bucket does not already exist, create it
aws s3 ls s3://captest-terraform >/dev/null 2>&1

if [ $? -eq 255 ]
then
   aws s3 mb s3://captest-terraform --region eu-west-1
   aws s3api put-bucket-versioning --bucket captest-terraform --versioning-configuration Status=Enabled
fi

cd $stack
terraform init
terraform $command

