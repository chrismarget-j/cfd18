resource "apstra_datacenter_resource_pool_allocation" "fabric_asn" {
  for_each     = toset(["spine_asns", "leaf_asns"])
  blueprint_id = apstra_datacenter_blueprint.cfd_18.id
  role         = each.key
  pool_ids     = ["Private-64512-65534"]
}

resource "apstra_datacenter_resource_pool_allocation" "fabric_ip4" {
  for_each     = toset(["spine_loopback_ips", "leaf_loopback_ips", "spine_leaf_link_ips"])
  blueprint_id = apstra_datacenter_blueprint.cfd_18.id
  role         = each.key
  pool_ids     = ["Private-192_168_0_0-16"]
}

resource "apstra_datacenter_resource_pool_allocation" "fabric_vni" {
  blueprint_id    = apstra_datacenter_blueprint.cfd_18.id
  role            = "evpn_l3_vnis"
  pool_ids        = ["Default-10000-20000"]
}
