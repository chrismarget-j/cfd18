resource "apstra_datacenter_routing_policy" "bgp" {
  blueprint_id  = data.terraform_remote_state.setup_fabric.outputs["blueprint_id"]
  name          = "AWS_IPSec_Handoff"
  import_policy = "extra_only"
  extra_imports = [
    { prefix = local.aws_cidr_block, action = "permit" },
  ]
  extra_exports = [
    { prefix = data.terraform_remote_state.deploy_app.outputs["app_subnet"], action = "permit" },
  ]
}

data "apstra_datacenter_ct_routing_policy" "bgp" {
  name              = "BGP Policy: AWS <--> Fabric"
  routing_policy_id = apstra_datacenter_routing_policy.bgp.id
}

locals {
  vyos_fabric_ips = [
    one([for i in docker_container.vyos.network_data : i.ip_address if i.network_name == module.apstra_transit_net[0].name]),
    one([for i in docker_container.vyos.network_data : i.ip_address if i.network_name == module.apstra_transit_net[1].name]),
  ]
}

data "apstra_datacenter_ct_bgp_peering_ip_endpoint" "bgp" {
  count = 2
  name         = "VyOS BGP session ${local.vyos_fabric_ips[count.index]}"
  ipv4_address = local.vyos_fabric_ips[count.index]
  neighbor_asn = 1000
  child_primitives = [
    data.apstra_datacenter_ct_routing_policy.bgp.primitive
  ]
}

resource "apstra_datacenter_connectivity_template" "bgp" {
  count = 2
  blueprint_id = data.terraform_remote_state.setup_fabric.outputs["blueprint_id"]
  name         = "IPSec to AWS transit ${count.index + 1}"
  primitives   = [data.apstra_datacenter_ct_bgp_peering_ip_endpoint.bgp[count.index].primitive]
}

resource "apstra_datacenter_connectivity_template_assignment" "svi_bgp" {
  count = 2
  blueprint_id              = data.terraform_remote_state.setup_fabric.outputs["blueprint_id"]
  application_point_id      = local.leaf_transit_svi_ids[count.index]
  connectivity_template_ids = [apstra_datacenter_connectivity_template.bgp[count.index].id]
}
