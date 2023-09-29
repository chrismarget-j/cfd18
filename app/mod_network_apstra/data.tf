data "apstra_datacenter_systems" "leafs" {
  blueprint_id = var.blueprint_id
  filters      = [{ role = "leaf" }]
}
