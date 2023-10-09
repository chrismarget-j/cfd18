resource "docker_container" "vyos" {
  image      = data.terraform_remote_state.setup_docker.outputs["image_ids"]["vyos"]
  name       = "vyos"
  privileged = true
  volumes {
    host_path      = "/lib/modules"
    container_path = "/lib/modules"
  }
  upload {
    file = "/opt/vyatta/etc/config/config.boot"
    content = templatefile("config.boot.tmpl", {
        leaf_1_ip = cidrhost(module.apstra_transit_net.ipv4_subnet, 2)

        tunnel_1_address            = data.terraform_remote_state.setup_aws.outputs["tunnel_1_address"]
        tunnel_1_cgw_inside_address = data.terraform_remote_state.setup_aws.outputs["tunnel_1_cgw_inside_address"]
        tunnel_1_vgw_inside_address = data.terraform_remote_state.setup_aws.outputs["tunnel_1_vgw_inside_address"]
        tunnel_1_preshared_key      = data.terraform_remote_state.setup_aws.outputs["tunnel_1_preshared_key"]

        tunnel_2_address            = data.terraform_remote_state.setup_aws.outputs["tunnel_2_address"]
        tunnel_2_cgw_inside_address = data.terraform_remote_state.setup_aws.outputs["tunnel_2_cgw_inside_address"]
        tunnel_2_vgw_inside_address = data.terraform_remote_state.setup_aws.outputs["tunnel_2_vgw_inside_address"]
        tunnel_2_preshared_key      = data.terraform_remote_state.setup_aws.outputs["tunnel_2_preshared_key"]
      })
  }
  networks_advanced {
    name = module.apstra_transit_net.name
  }
  networks_advanced {
    name = "bridge"
  }
  entrypoint = ["/sbin/init"]
  depends_on = [module.docker_transit_net]
}

#output "config" {
#  value = templatefile("config.boot.tmpl",
#    {
#      tunnel1_cgw_inside_address = aws_vpn_connection.main.tunnel1_address
#      leaf_1_ip = cidrhost(module.apstra_transit_net.ipv4_subnet, 2)
#      tunnel1_vgw_inside_address = aws_vpn_connection.main.tunnel1_vgw_inside_address
#      tunnel1_address = aws_vpn_connection.main.tunnel1_address
#      tunnel1_preshared_key = aws_vpn_connection.main.tunnel1_preshared_key
#    },
#  )
#}
