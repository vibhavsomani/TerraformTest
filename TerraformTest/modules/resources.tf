/*VPC Creation */
resource "aws_vpc" "MyVPC" {
  cidr_block = "10.0.0.0/20"
  enable_dns_support = "true"
  tags = {
	resource-name = "My Custom VPC"
	environment = var.environment
	region = var.region
	Creation-Time = var.Creation-Time
  }
}
/*IGW Creation */
resource "aws_internet_gateway" "MyIGW" {
  vpc_id = aws_vpc.MyVPC.id
  tags = {
	resource-name = "My Custom IGW"
	environment = var.environment
	region = var.region
	Creation-Time = var.Creation-Time
  }
}

/*EIP Creation */
resource "aws_eip" "nat_eip" {
  vpc = true
  depends_on = [aws_internet_gateway.MyIGW]
}

/*NAT Gateway Creation */
  resource "aws_nat_gateway" "MyNAT" {
  allocation_id = "aws_eip.nat_eip.id"
  subnet_id = "aws_subnet.public_subnet"
  depends_on = [aws_internet_gateway.MyIGW , aws_subnet.public_subnet]
  tags = {
	resource-name = "My Custom NAT"
	environment = var.environment
	region = var.region
	Creation-Time = var.Creation-Time
  }
}

/*Public Subnet */
resource "aws_subnet" "public_subnet" {
  vpc_id = "${aws_vpc.MyVPC.id}"
  count = "${length(var.public_subnets_cidr)}"
  cidr_block = "10.0.10.0/24"
  availability_zone = "${element(var.availability_zone, count.index)}"
  map_public_ip_on_launch = true
  tags = {
	resource-name = "Public Subnet"
	environment = var.environment
	region = var.region
	Creation-Time = var.Creation-Time
  }
}

/* Private subnet */
resource "aws_subnet" "private_subnet" {
  vpc_id                  = "${aws_vpc.MyVPC.id}"
  count                   = "${length(var.private_subnets_cidr)}"
  cidr_block              = "${element(var.private_subnets_cidr, count.index)}"
  availability_zone       = "${element(var.availability_zone, count.index)}"
  map_public_ip_on_launch = false
   tags = {
	resource-name = "Private Subnet"
	environment = var.environment
	region = var.region
	Creation-Time = var.Creation-Time
  }
}

/* Routing table for private subnet */
resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.MyVPC.id}"
}

/* Routing table for public subnet */
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.MyVPC.id}"
  tags = {
    Name = "${var.environment}-public-route-table"
    Environment = "${var.environment}"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.MyIGW.id}"
}
resource "aws_route" "private_nat_gateway" {
  route_table_id = "${aws_route_table.private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.MyNAT.id}"
}
/* Route table associations */
resource "aws_route_table_association" "public" {
  count = "${length(var.public_subnets_cidr)}"
  subnet_id = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}
resource "aws_route_table_association" "private" {
  count = "${length(var.private_subnets_cidr)}"
  subnet_id = "${element(aws_subnet.private_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}

/* VPC's Default Security Group */
resource "aws_security_group" "SG" {
  name = "${var.environment}-default-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id = "${aws_vpc.MyVPC.id}"
  depends_on  = [aws_vpc.MyVPC]
  ingress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
  }
  
  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
  }
   tags = {
	resource-name = "My Custom SG"
	environment = var.environment
	region = var.region
	Creation-Time = var.Creation-Time
  }
}