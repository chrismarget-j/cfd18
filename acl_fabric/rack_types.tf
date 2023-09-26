# Locals are variables available for use only within the project directory.
# They're not available for use across Terraform Module boundaries. Here we
# use "single_homed" and "dual_homed" as shorthand for Apstra Logical Device
# IDs we need when creating Generic Systems (servers) in our Rack Types.
locals {
  server_ld = "AOS-2x10-1"
}

resource "apstra_rack_type" "rack_a" {
  name                       = "rack_a"
  fabric_connectivity_design = "l3clos"
  leaf_switches = {
    leaf_a = {
      logical_device_id = "virtual-7x10-1"
      spine_link_count    = 1
      spine_link_speed    = "10G"
      redundancy_protocol = "esi"
    }
#    leaf_b = {
#      logical_device_id = "virtual-7x10-1"
#      spine_link_count    = 1
#      spine_link_speed    = "10G"
#    }
  }
}

resource "apstra_rack_type" "rack_b" {
  name                       = "rack_b"
  fabric_connectivity_design = "l3clos"
  leaf_switches = {
    leaf_a = {
      logical_device_id = "virtual-7x10-1"
      spine_link_count  = 1
      spine_link_speed  = "10G"
    }
  }
}
