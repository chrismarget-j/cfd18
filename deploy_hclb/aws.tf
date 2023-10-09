resource "aws_vpc" "o" {
  cidr_block = local.aws_cidr_block
  tags       = { Name = "cfd18" }
}

resource "aws_subnet" "o" {
  vpc_id = aws_vpc.o.id
  cidr_block = cidrsubnet(aws_vpc.o.cidr_block, 8, 1)
  tags = {
    Name = "test"
  }
  availability_zone = "us-east-1b"
}

resource "aws_internet_gateway" "o" {
  vpc_id = aws_vpc.o.id
}

resource "aws_route" "o" {
  route_table_id = aws_vpc.o.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.o.id
}

resource "aws_vpn_gateway" "o" {
  vpc_id          = aws_vpc.o.id
  tags            = { Name = "cfd18" }
  amazon_side_asn = 7224
}

resource "aws_vpn_gateway_route_propagation" "example" {
  vpn_gateway_id = aws_vpn_gateway.o.id
  route_table_id = aws_vpc.o.main_route_table_id
}

resource "aws_customer_gateway" "o" {
  bgp_asn     = 1000
  type        = "ipsec.1"
  ip_address  = data.external.pub_ip.result["ip"]
  device_name = "vyos"
}

resource "aws_vpn_connection" "main" {
  vpn_gateway_id      = aws_vpn_gateway.o.id
  customer_gateway_id = aws_customer_gateway.o.id
  type                = "ipsec.1"
}
