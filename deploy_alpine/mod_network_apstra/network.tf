data "apstra_datacenter_virtual_network_binding_constructor" "o" {
  blueprint_id = var.blueprint_id
  switch_ids   = data.apstra_datacenter_systems.leafs.ids
  vlan_id      = var.vlan_id
}

resource "apstra_datacenter_virtual_network" "o" {
  blueprint_id                 = var.blueprint_id
  routing_zone_id              = var.routing_zone_id
  type                         = "vxlan"
  name                         = var.name
  ipv4_connectivity_enabled    = true
  ipv4_virtual_gateway_enabled = true
  reserve_vlan                 = var.vlan_id != null
  bindings                     = data.apstra_datacenter_virtual_network_binding_constructor.o.bindings
}

data "apstra_datacenter_ct_virtual_network_single" "o" {
  vn_id  = apstra_datacenter_virtual_network.o.id
  tagged = true
}

resource "apstra_datacenter_connectivity_template" "o" {
  blueprint_id = var.blueprint_id
  name         = var.name
  primitives   = [data.apstra_datacenter_ct_virtual_network_single.o.primitive]
}

data "apstra_datacenter_interfaces_by_link_tag" "docker_interfaces" {
  blueprint_id = var.blueprint_id
  tags         = ["docker"]
}

resource "apstra_datacenter_connectivity_template_assignment" "o" {
  for_each             = toset(data.apstra_datacenter_interfaces_by_link_tag.docker_interfaces.ids)
  blueprint_id         = var.blueprint_id
  application_point_id = each.key
  connectivity_template_ids = [
    apstra_datacenter_connectivity_template.o.id
  ]
}
