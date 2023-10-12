resource "apstra_datacenter_routing_zone" "cfd_18" {
  name         = var.routing_zone_name
  blueprint_id = apstra_datacenter_blueprint.cfd_18.id
}

resource "apstra_datacenter_resource_pool_allocation" "rz_loopbacks" {
  blueprint_id    = apstra_datacenter_blueprint.cfd_18.id
  routing_zone_id = apstra_datacenter_routing_zone.cfd_18.id
  role            = "leaf_loopback_ips"
  pool_ids        = ["Private-192_168_0_0-16"]
}
