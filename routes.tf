resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name        = "rtb-${var.tags["environment"]}-${var.tags["Name"]}-public"
    project     = "${var.tags["project"]}"
    environment = "${var.tags["environment"]}"
    cost-center = "${var.tags["cost-center"]}"
    creator     = "${var.tags["creator"]}"
  }
}

resource "aws_route" "igw" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}

resource "aws_route" "igw-v6" {
  route_table_id              = "${aws_route_table.public.id}"
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = "${aws_internet_gateway.igw.id}"
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.availability-zones)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table" "private" {
  count  = "${length(var.availability-zones)}"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name        = "rtb-${var.tags["environment"]}-${var.tags["Name"]}-${element(var.availability-zones, count.index)}-private"
    project     = "${var.tags["project"]}"
    environment = "${var.tags["environment"]}"
    cost-center = "${var.tags["cost-center"]}"
    creator     = "${var.tags["creator"]}"
  }
}

resource "aws_route" "nat" {
  count                  = "${length(var.availability-zones)}"
  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.ngw.*.id, count.index)}"
}

resource "aws_route" "igw-private-v6" {
  count                       = "${length(var.availability-zones)}"
  route_table_id              = "${element(aws_route_table.private.*.id, count.index)}"
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = "${aws_internet_gateway.igw.id}"
}

resource "aws_route_table_association" "private" {
  count          = "${length(var.availability-zones)}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}
