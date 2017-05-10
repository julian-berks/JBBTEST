# Julian Berks - Capgemini Terraform test - May 2017
Scripts compatible with terraform version 0.9.4

Pre-requisites
==============
1) terraform (minimum version 0.9.4) 
2) AWS command line interface installed and configured to log into an appropriate AWS account with sufficient privileges to build all necessary components. AWS AdministratorAccess is recommended. Details on how to do this differ between AWS implementations and are therefore out of scope of this document.
3) The automation scripts assume you are running on a unix server.

Description
===========
This set of scripts creates a VPC with internet gateway, 2 Subnets (app and DMZ), a NAT gateway for use by the app servers,  security groups and an autoscaling group to create 2 applications servers (configurable).
On start-up, each server pulls a binary copy of the application from a separate Git Hub code repository (julian-berks/Capgemini-Code/master/GoTest) and executes it.
An elastic load balancer manages traffic to the application and listens on port 80.

A build.sh shell script is provided to, if necessary, create the backend S3 bucket needed to store the state files, automate the initialisation of terraform and run the build process.

A teardown.sh script is also provided to automate the deletion of the stack.

An SSH key for the EC2 instances and a "Bastion security group" has been provided to assist in the creation of an EC2 bastion server should access to the servers be required. However, for security reasons, no bastion server has been provided.

Names are configured to enable Dev/Prod stacks to be built in the same AWS account if required.

To run
======
1) Pull this repository down to your unix machine
2) run build.sh with the appropriate task (plan or apply) as parameter 1 and stack name as parameter 2 (e.g. build.sh plan Dev)
3) After a successful build, terraform should complete with the following

Apply complete! Resources: 30 added, 0 changed, 0 destroyed.

The state of your infrastructure has been saved to the path
below. This state is required to modify and destroy your
infrastructure, so keep it safe. To inspect the complete state
use the `terraform show` command.

State path: 

Outputs:

application-url = load-balancer-770749828.eu-west-1.elb.amazonaws.com


To Test
=======
Enter the application-url returned above into your browser.

to Modify
=========
Most settings, including the region and availability zones are configurable via variables defined in the main.tf file.

Logging
=======
EC2 instance and application logs are available in cloud watch.

ELB logs are written to an S3 bucket identified by the elb-log-bucket variable within the appropriate main.tf.


To tear down the stack
======================
1) run teardown.sh with the appropriate stack name (e.g. teardown.sh Dev)
2) Answer yes when prompted.




Suggested Future Enhancements
=============================

rewrite the 2 shell scripts in python to allow for different operating systems.

The ELB should be switched to using https (no approved CA available at this time).

The ELB DNS name should be aliased with a more friendly DNS name.

All terraform modules are currently in the same Git repository. It would be advisable to split modules into separate repositories and utilise the Git source capability of the terraform modules mechanism. This would simplify multiple team co-operation.

Keys should be extracted from this git repository and relocated into a secure store, such as Vault.

Whilst unnecessarily complex for the current scenario, splitting out into additional modules should be considered for any additional functionality.

Docker should be considered as an alternative to the current git hosted executable.

Monitor the clodwatch and S3 logs using an ELK stack or Splunk. (Note: The app currently produces no output).



