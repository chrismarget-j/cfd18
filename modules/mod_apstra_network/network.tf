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
  ipv4_subnet                  = var.ipv4_subnet
  ipv4_connectivity_enabled    = true
  ipv4_virtual_gateway_enabled = true
  reserve_vlan                 = var.vlan_id != null
  bindings                     = data.apstra_datacenter_virtual_network_binding_constructor.o.bindings
}

data "apstra_datacenter_ct_virtual_network_single" "tagged" {
  vn_id  = apstra_datacenter_virtual_network.o.id
  tagged = true
  name   = "${var.name} tagged"
}

resource "apstra_datacenter_connectivity_template" "tagged" {
  blueprint_id = var.blueprint_id
  name         = "${var.name} tagged"
  primitives   = [data.apstra_datacenter_ct_virtual_network_single.tagged.primitive]
}

data "apstra_datacenter_ct_virtual_network_single" "untagged" {
  vn_id  = apstra_datacenter_virtual_network.o.id
  tagged = false
  name   = "${var.name} untagged"
}

resource "apstra_datacenter_connectivity_template" "untagged" {
  blueprint_id = var.blueprint_id
  name         = "${var.name} untagged"
  primitives   = [data.apstra_datacenter_ct_virtual_network_single.untagged.primitive]
}
