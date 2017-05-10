##########################################################
# Create scaling groups and associated components 
##########################################################


# #####################   AMI     #########################################################
# #########################################################################################
# Look up the container AMI 
data "aws_ami" "container" {
  most_recent = true
  filter {
   name="name"
   values = ["amzn-ami-hvm-*-x86_64-gp2"]

  }
}

# #####################   Clusters     ####################################################
# #########################################################################################
# Clusters
resource "aws_ecs_cluster" "app_server" {
  name = "app"
}


# #####################   Launch Configuration   ##########################################
# #########################################################################################
#  App Server Launch Configuration
resource "aws_launch_configuration" "app" {
    name_prefix = "app-"
    image_id = "${data.aws_ami.container.id}"
    instance_type = "t2.micro"
    user_data = "${file("../Go-App/app-user-data.txt")}"
    security_groups = ["${aws_security_group.app.id}"]
    iam_instance_profile = "${aws_iam_instance_profile.ec2_server_role.id}"
    key_name = "${var.stack-name}-ssh_key"
    associate_public_ip_address = false
    lifecycle {
                create_before_destroy = true
              }
}

# #####################  Scaling Group      ###############################################
# #########################################################################################
# App Server Scaling Group
resource "aws_autoscaling_group" "app" {
    name = "${var.stack-name}-app-scaling-group"
    availability_zones = ["${var.zones}"]
    vpc_zone_identifier = [ "${aws_subnet.app_subnet.*.id}"]
    launch_configuration = "${aws_launch_configuration.app.name}"
    min_size = "${var.min-instances}"
    max_size = "${var.max-instances}"
    load_balancers = ["${aws_elb.load_balancer.name}"]
    lifecycle {
          create_before_destroy = true
         }
	  tag {
    key = "Name"
    value = "App-Server"
    propagate_at_launch = "true"
      }
}

