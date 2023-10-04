resource "apstra_rack_type" "rack" {
  name                       = "CFD 18 Rack"
  fabric_connectivity_design = "l3clos"
  leaf_switches = {
    leaf = {
      logical_device_id = "virtual-7x10-1"
      spine_link_count  = 1
      spine_link_speed  = "10G"
    }
  }
}
