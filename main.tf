resource "aws_vpc" "main" {
  cidr_block                       = "${var.allocated-cidr}"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name        = "vpc-${var.tags["environment"]}-${var.tags["Name"]}"
    project     = "${var.tags["project"]}"
    environment = "${var.tags["environment"]}"
    cost-center = "${var.tags["cost-center"]}"
    creator     = "${var.tags["creator"]}"
  }
}

resource "aws_subnet" "private" {
  count                           = "${length(var.availability-zones)}"
  vpc_id                          = "${aws_vpc.main.id}"
  cidr_block                      = "${cidrsubnet(aws_vpc.main.cidr_block, length(var.availability-zones), count.index)}"
  ipv6_cidr_block                 = "${cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index)}"
  availability_zone               = "${var.region}${element(var.availability-zones, count.index)}"
  assign_ipv6_address_on_creation = true

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name        = "sub-${var.tags["environment"]}-${var.tags["Name"]}-${element(var.availability-zones, count.index)}-private"
    project     = "${var.tags["project"]}"
    environment = "${var.tags["environment"]}"
    cost-center = "${var.tags["cost-center"]}"
    creator     = "${var.tags["creator"]}"
    Tier        = "private"
  }
}

resource "aws_subnet" "public" {
  count                           = "${length(var.availability-zones)}"
  vpc_id                          = "${aws_vpc.main.id}"
  cidr_block                      = "${cidrsubnet(aws_vpc.main.cidr_block, length(var.availability-zones), length(var.availability-zones) + count.index)}"
  ipv6_cidr_block                 = "${cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, length(var.availability-zones) + count.index)}"
  availability_zone               = "${var.region}${element(var.availability-zones, count.index)}"
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = true

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name        = "sub-${var.tags["environment"]}-${var.tags["Name"]}-${element(var.availability-zones, count.index)}-public"
    project     = "${var.tags["project"]}"
    environment = "${var.tags["environment"]}"
    cost-center = "${var.tags["cost-center"]}"
    creator     = "${var.tags["creator"]}"
    Tier        = "public"
  }
}

resource "aws_nat_gateway" "ngw" {
  count         = "${length(var.availability-zones)}"
  subnet_id     = "${aws_subnet.public.*.id[count.index]}"
  allocation_id = "${aws_eip.nat.*.id[count.index]}"

  tags {
    Name        = "ngw-${var.tags["environment"]}-${var.tags["Name"]}-nat-gateway"
    project     = "${var.tags["project"]}"
    environment = "${var.tags["environment"]}"
    cost-center = "${var.tags["cost-center"]}"
    creator     = "${var.tags["creator"]}"
  }
}

resource "aws_eip" "nat" {
  count = "${length(var.availability-zones)}"
  vpc   = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.main.id}"

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name        = "igw-${var.tags["environment"]}-${var.tags["Name"]}-internet-gateway"
    project     = "${var.tags["project"]}"
    environment = "${var.tags["environment"]}"
    cost-center = "${var.tags["cost-center"]}"
    creator     = "${var.tags["creator"]}"
  }
}
