module "apstra_transit_net" {
  source          = "../modules/mod_apstra_network"
  blueprint_id    = data.terraform_remote_state.setup_fabric.outputs["blueprint_id"]
  name            = "transit"
  routing_zone_id = data.terraform_remote_state.setup_fabric.outputs["routing_zone_id"]
}

module "docker_transit_net" {
  source          = "../modules/mod_network_docker"
  name            = module.apstra_transit_net.name
  subnet          = module.apstra_transit_net.ipv4_subnet
  vlan            = module.apstra_transit_net.vlan_id
  worker_instance = 4
}

data "apstra_datacenter_interfaces_by_link_tag" "bgp" {
  blueprint_id = data.terraform_remote_state.setup_fabric.outputs["blueprint_id"]
  tags         = ["S4", "eth1"]
}

resource "apstra_datacenter_connectivity_template_assignment" "lb" {
  blueprint_id              = data.terraform_remote_state.setup_fabric.outputs["blueprint_id"]
  application_point_id      = one(data.apstra_datacenter_interfaces_by_link_tag.bgp.ids)
  connectivity_template_ids = [module.apstra_transit_net.ct_tagged]
}
