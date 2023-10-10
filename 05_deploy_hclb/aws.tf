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

resource "aws_vpn_gateway_attachment" "o" {
  vpc_id = aws_vpc.o.id
  vpn_gateway_id = data.terraform_remote_state.setup_aws.outputs["vpg_id"]
}

resource "aws_vpn_gateway_route_propagation" "example" {
  vpn_gateway_id = data.terraform_remote_state.setup_aws.outputs["vpg_id"]
  route_table_id = aws_vpc.o.main_route_table_id
}
