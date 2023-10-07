resource "apstra_ipv4_pool" "o" {
  name    = "CFD 18 Apps"
  subnets = [for i in local.app_prefixes : { network = i }]

  connection {
    type        = "ssh"
    user        = "admin"
    host        = "s4"
    private_key = file("../.ssh_key")
  }

  provisioner "remote-exec" {
    inline = [for i in local.app_prefixes :
      "if ! sudo ip route add ${i} via ${cidrhost(data.terraform_remote_state.setup_fabric.outputs["lb_subnet"], 1)}; then :; fi"
    ]
  }
}

resource "apstra_datacenter_resource_pool_allocation" "cfd_apps" {
  blueprint_id    = data.terraform_remote_state.setup_fabric.outputs["blueprint_id"]
  routing_zone_id = data.terraform_remote_state.setup_fabric.outputs["routing_zone_id"]
  role            = "virtual_network_svi_subnets"
  pool_ids        = [apstra_ipv4_pool.o.id]
}
