resource "aws_vpn_gateway" "o" {
  tags            = { Name = "cfd18" }
  amazon_side_asn = 7224
}

resource "aws_customer_gateway" "o" {
  bgp_asn     = 1000
  type        = "ipsec.1"
  ip_address  = data.external.pub_ip.result["ip"]
  device_name = "vyos"
}

resource "aws_vpn_connection" "o" {
  vpn_gateway_id      = aws_vpn_gateway.o.id
  customer_gateway_id = aws_customer_gateway.o.id
  type                = "ipsec.1"
}
