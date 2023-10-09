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
  vyos_fabric_ip = one([ for i in docker_container.vyos.network_data : i.ip_address if i.network_name == module.apstra_transit_net.name ])
}

data "apstra_datacenter_ct_bgp_peering_ip_endpoint" "bgp" {
  name         = "VyOS BGP session"
  ipv4_address = local.vyos_fabric_ip
  neighbor_asn = 1000
  child_primitives = [
    data.apstra_datacenter_ct_routing_policy.bgp.primitive
  ]
}

resource "apstra_datacenter_connectivity_template" "bgp" {
  blueprint_id = data.terraform_remote_state.setup_fabric.outputs["blueprint_id"]
  name         = "IPSec to AWS"
  primitives   = [data.apstra_datacenter_ct_bgp_peering_ip_endpoint.bgp.primitive]
}

resource "apstra_datacenter_connectivity_template_assignment" "svi_bgp" {
  blueprint_id              = data.terraform_remote_state.setup_fabric.outputs["blueprint_id"]
  application_point_id      = local.leaf_1_transit_svi_id
  connectivity_template_ids = [apstra_datacenter_connectivity_template.bgp.id]
}
