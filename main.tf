data "aws_availability_zones" "available" {}
 resource "aws_vpc" "todo_vpc" {                # Creating VPC here
   cidr_block       = var.vpc_cidr    # Defining the CIDR block
   instance_tenancy = "default"
   enable_dns_hostnames = "true"
    enable_dns_support = "true"
   tags = {
        Name = "todo_vpc"
    }
 }

 resource "aws_internet_gateway" "IGW" {    # Creating Internet Gateway
    vpc_id =  aws_vpc.todo_vpc.id # vpc_id will be generated after we create VPC
   tags = {
        Name = "internet gw"
    }
 }

 resource "aws_subnet" "PublicAZ" {
    count = length(data.aws_availability_zones.available.names)
    vpc_id = aws_vpc.todo_vpc.id
    cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index + 1)
    map_public_ip_on_launch = true
  tags = {
        Name = "Todot ${data.aws_availability_zones.available.names[count.index]}"
  }
    availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
}

 resource "aws_route_table" "PublicRT" {    # Creating RT for Public Subnet
    vpc_id =  aws_vpc.todo_vpc.id
    tags = {
      Name = "PublicRT"
    }
   route {
    cidr_block = "0.0.0.0/0"               # Traffic from Public Subnet reaches Internet via Internet Gateway
    gateway_id = aws_internet_gateway.IGW.id
     }
 }

resource "aws_route_table_association" "PublicAZA" {
    count = length(aws_subnet.PublicAZ)
    subnet_id = element(aws_subnet.PublicAZ.*.id, count.index)
    route_table_id = aws_route_table.PublicRT.id
}
#output "subnets_public" {
#  value = "${aws_subnet.PublicAZ.*.id}"
#}
