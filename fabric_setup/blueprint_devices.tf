locals {
  last_octet_to_fabric_name = {
    11 = "spine1"
    12 = "spine2"
    13 = "rack_001_leaf1"
    14 = "rack_003_leaf1"
    15 = "rack_002_leaf1"
  }
}

resource "apstra_datacenter_device_allocation" "each" {
  for_each                 = data.apstra_agent.each
  blueprint_id             = apstra_datacenter_blueprint.cfd_18.id
  initial_interface_map_id = "Juniper_vEX__slicer-7x10-1"
  node_name                = local.last_octet_to_fabric_name[split(".", each.value.management_ip)[3]]
  device_key               = each.value.device_key
  deploy_mode              = "deploy"
}
