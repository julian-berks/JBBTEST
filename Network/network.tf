##########################################################
# Network
# Create Network components 
##########################################################


provider "aws" {
    region = "${var.region}"
}


# Create a VPC
resource "aws_vpc" "vpc" {
	cidr_block = "${var.cidr-block}"
	enable_dns_support = true
	enable_dns_hostnames = true
    tags {
        Name = "${var.vpc-name}"
    }
}



#######                          SUBNETS              #################################################

# APP
resource "aws_subnet" "app_subnet" {
  count                   = "${length(var.zones)}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${cidrsubnet(var.cidr-block, 8, (var.ip-base-value + count.index))}"
  map_public_ip_on_launch = false
  availability_zone       = "${element(var.zones, count.index)}"
  tags {
    Name = "${format("%s%s","app-", "${element(var.zones, count.index)}")}"
  }
}

# DMZ
resource "aws_subnet" "dmz_subnet" {
  count                   = "${length(var.zones)}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${cidrsubnet(var.cidr-block, 8, (var.ip-base-value + count.index + 9 ))}"
  map_public_ip_on_launch = false
  availability_zone       = "${element(var.zones, count.index)}"
  tags {
    Name = "${format("%s%s","dmz-", "${element(var.zones, count.index)}")}"
  }
}




#################################   Elastic_IP   #################################################
#Nat Gateway EIP
resource "aws_eip" "NAT" {
    count    = "${length(var.zones)}"
    vpc      = true
}



##################################   Gateways    #################################################
# NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
   count = "${length(var.zones)}"
   allocation_id = "${element(aws_eip.NAT.*.id,count.index)}"
   subnet_id = "${element(aws_subnet.dmz_subnet.*.id,count.index)}"
}
 
 # Internet Gateway
 resource "aws_internet_gateway" "gateway" {
    vpc_id = "${aws_vpc.vpc.id}"
    tags {
        Name = "main-Internet-GW"
    }
}
 
 
 #################################   Routing Tables   #################################################
 # Local routing is implicit
 # DMZ
 resource "aws_route_table" "dmz_route_table" {
    vpc_id = "${aws_vpc.vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gateway.id}"
    }
    tags {
        Name = "dmz"
    }
}
 
 ########
 # App
  resource "aws_route_table" "app_route_table" {
    count = "${length(var.zones)}"
    vpc_id = "${aws_vpc.vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${element(aws_nat_gateway.nat_gateway.*.id,count.index)}"
    }
    tags {
        Name = "app"
    }
}
 


#########################  Route Table Associations   #########################################

# APP
resource "aws_route_table_association" "app_routing" {
    count = "${length(var.zones)}"
    subnet_id = "${element(aws_subnet.app_subnet.*.id,count.index)}"
    route_table_id = "${element(aws_route_table.app_route_table.*.id,count.index)}"
}


# DMZ 
resource "aws_route_table_association" "dmz_routing" {
    count = "${length(var.zones)}"
    subnet_id = "${element(aws_subnet.dmz_subnet.*.id,count.index)}"
    route_table_id = "${aws_route_table.dmz_route_table.id}"
}


