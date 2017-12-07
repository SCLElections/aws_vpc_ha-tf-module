resource "aws_route_table" "public" {
  provider = "aws.local"
  vpc_id   = "${aws_vpc.main.id}"

  tags {
    Name        = "rtb-${var.tags["environment"]}-${var.tags["Name"]}-public"
    project     = "${var.tags["project"]}"
    environment = "${var.tags["environment"]}"
    cost-center = "${var.tags["cost-center"]}"
    creator     = "${var.tags["creator"]}"
  }
}

resource "aws_route" "igw" {
  provider               = "aws.local"
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}

resource "aws_route" "igw-v6" {
  provider                    = "aws.local"
  route_table_id              = "${aws_route_table.public.id}"
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = "${aws_internet_gateway.igw.id}"
}

resource "aws_route_table_association" "public" {
  provider       = "aws.local"
  count          = "${length(var.availability-zones)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table" "private" {
  provider = "aws.local"
  count    = "${length(var.availability-zones)}"
  vpc_id   = "${aws_vpc.main.id}"

  tags {
    Name        = "rtb-${var.tags["environment"]}-${var.tags["Name"]}-private"
    project     = "${var.tags["project"]}"
    environment = "${var.tags["environment"]}"
    cost-center = "${var.tags["cost-center"]}"
    creator     = "${var.tags["creator"]}"
  }
}

resource "aws_route" "nat" {
  provider               = "aws.local"
  count                  = "${length(var.availability-zones)}"
  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.ngw.*.id, count.index)}"
}

resource "aws_route" "igw-private-v6" {
  provider                    = "aws.local"
  count                       = "${length(var.availability-zones)}"
  route_table_id              = "${element(aws_route_table.private.*.id, count.index)}"
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = "${aws_internet_gateway.igw.id}"
}

resource "aws_route_table_association" "private" {
  provider       = "aws.local"
  count          = "${length(var.availability-zones)}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}
