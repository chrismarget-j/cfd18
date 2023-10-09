output "vpg_id" { value = aws_vpn_gateway.o.id }

output "tunnel_1_address" { value = aws_vpn_connection.o.tunnel1_address }
output "tunnel_1_cgw_inside_address" { value = aws_vpn_connection.o.tunnel1_cgw_inside_address }
output "tunnel_1_vgw_inside_address" { value = aws_vpn_connection.o.tunnel1_vgw_inside_address }
output "tunnel_1_preshared_key" {
  value     = aws_vpn_connection.o.tunnel1_preshared_key
  sensitive = true
}

output "tunnel_2_address" { value = aws_vpn_connection.o.tunnel2_address }
output "tunnel_2_cgw_inside_address" { value = aws_vpn_connection.o.tunnel2_cgw_inside_address }
output "tunnel_2_vgw_inside_address" { value = aws_vpn_connection.o.tunnel2_vgw_inside_address }
output "tunnel_2_preshared_key" {
  value     = aws_vpn_connection.o.tunnel2_preshared_key
  sensitive = true
}
