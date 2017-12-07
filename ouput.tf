output "public-subnets" {
  value = ["${aws_subnet.public.*.id}"]
}

output "private-subnets" {
  value = ["${aws_subnet.private.*.id}"]
}

output "public-route-table" {
  value = ["${aws_route_table.public.id}"]
}

output "private-route-table" {
  value = ["${aws_route_table.private.*.id}"]
}

output "id" {
  value = "${aws_vpc.main.id}"
}

output "cidr" {
  value = "${aws_vpc.main.cidr_block}"
}

output "ngw" {
  value = "${aws_nat_gateway.ngw.*.id}"
}

output "igw" {
  value = "${aws_internet_gateway.igw.id}"
}

output "ipv6-cidr" {
  value = "${aws_vpc.main.ipv6_cidr_block}"
}
