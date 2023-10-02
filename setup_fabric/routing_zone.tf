resource "apstra_datacenter_routing_zone" "cfd_18" {
  name         = "blue"
  blueprint_id = apstra_datacenter_blueprint.cfd_18.id
}

resource "apstra_datacenter_resource_pool_allocation" "blue_loopbacks" {
  blueprint_id    = apstra_datacenter_blueprint.cfd_18.id
  routing_zone_id = apstra_datacenter_routing_zone.cfd_18.id
  role            = "leaf_loopback_ips"
  pool_ids        = ["Private-192_168_0_0-16"]
}

resource "apstra_datacenter_resource_pool_allocation" "blue_subnets" {
  blueprint_id    = apstra_datacenter_blueprint.cfd_18.id
  routing_zone_id = apstra_datacenter_routing_zone.cfd_18.id
  role            = "virtual_network_svi_subnets"
  pool_ids        = [apstra_ipv4_pool.app.id]
}
