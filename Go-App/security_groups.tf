###################################################################################
# Security Groups
###################################################################################

###################################################################################
# App
resource "aws_security_group" "app" {
    name = "App"
    description = "App Tier Security Group"
    vpc_id = "${aws_vpc.vpc.id}"

    # Allow SSH from a bastion
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = ["${aws_security_group.bastion_sg.id}"]
	     }

  # port 8484 from the Load Balancer
    ingress {
        from_port = 8484
        to_port = 8484
        protocol = "tcp"
        security_groups = ["${aws_security_group.elb.id}"]
    }
	
    # Allow all outgoing traffic.
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
      Name = "app-sg"
    }
}

########################   ELB    ###################################################
# External-ELB
resource "aws_security_group" "elb" {
    name = "elb"
    description = "For External ELB to recieve traffic"
    vpc_id = "${aws_vpc.vpc.id}"

    # Allow HTTP from External
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
       }


# Allow all outgoing traffic.
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags {
      Name = "elb-sg"
    }
}

###################################################################################
# Bastion SG   
resource "aws_security_group" "bastion_sg" {
    name = "bastion-sg"
    description = "For inbound traffic to the Bastion"
    vpc_id = "${aws_vpc.vpc.id}"

    # Allow SSH from the internet (Unsafe - Would normally lock to Corporate network)
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
		  }

	
# Allow all outgoing traffic.
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags {
      Name = "Bastion"
    }
}
