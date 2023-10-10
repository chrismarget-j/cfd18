module "apstra_transit_net" {
  count           = 2
  source          = "../modules/mod_apstra_network"
  blueprint_id    = data.terraform_remote_state.setup_fabric.outputs["blueprint_id"]
  name            = "transit-${1 + count.index}"
  routing_zone_id = data.terraform_remote_state.setup_fabric.outputs["routing_zone_id"]
}

module "docker_transit_net" {
  count           = 2
  source          = "../modules/mod_network_docker"
  name            = module.apstra_transit_net[count.index].name
  subnet          = module.apstra_transit_net[count.index].ipv4_subnet
  vlan            = module.apstra_transit_net[count.index].vlan_id
  interface       = "eth${1 + count.index}"
  worker_instance = 4
}

data "apstra_datacenter_interfaces_by_link_tag" "bgp" {
  count        = 2
  blueprint_id = data.terraform_remote_state.setup_fabric.outputs["blueprint_id"]
  tags         = ["S4", "eth${1 + count.index}"]
}

resource "apstra_datacenter_connectivity_template_assignment" "lb" {
  count                     = 2
  blueprint_id              = data.terraform_remote_state.setup_fabric.outputs["blueprint_id"]
  application_point_id      = one(data.apstra_datacenter_interfaces_by_link_tag.bgp[count.index].ids)
  connectivity_template_ids = [module.apstra_transit_net[count.index].ct_tagged]
}
