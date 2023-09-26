# Locals are variables available for use only within the project directory.
# They're not available for use across Terraform Module boundaries. Here we
# use "single_homed" and "dual_homed" as shorthand for Apstra Logical Device
# IDs we need when creating Generic Systems (servers) in our Rack Types.
locals {
  server_ld = "AOS-2x10-1"
}

resource "apstra_rack_type" "lab_guide_single" {
  name                       = "apstra-single"
  fabric_connectivity_design = "l3clos"
  leaf_switches = {
    apstra-single = {
      logical_device_id = "virtual-7x10-1"
      spine_link_count  = 1
      spine_link_speed  = "10G"
    }
  }
  generic_systems = {
    single-server = {
      count             = 1
      logical_device_id = "AOS-1x10-1"
      links = {
        single-link = {
          target_switch_name = "apstra-single"
          links_per_switch   = 1
          speed              = "10G"
        }
      }
    }
  }
}

resource "apstra_rack_type" "lab_guide_esi" {
  name                       = "apstra-esi"
  fabric_connectivity_design = "l3clos"
  leaf_switches = {
    apstra-esi = {
      logical_device_id = "virtual-7x10-1"
      spine_link_count    = 1
      spine_link_speed    = "10G"
      redundancy_protocol = "esi"
    }
  }
  generic_systems = {
    dual-server = {
      count             = 1
      logical_device_id = "AOS-2x10-1"
      links = {
        redundant-link = {
          target_switch_name = "apstra-esi"
          links_per_switch   = 1
          speed              = "10G"
          lag_mode           = "lacp_active"
        }
      }
    }
    single-server-1 = {
      count             = 1
      logical_device_id = "AOS-1x10-1"
      links = {
        single-link = {
          target_switch_name = "apstra-esi"
          links_per_switch   = 1
          speed              = "10G"
          switch_peer        = "first"
        }
      }
    }
    single-server-2 = {
      count             = 1
      logical_device_id = "AOS-1x10-1"
      links = {
        single-link = {
          target_switch_name = "apstra-esi"
          links_per_switch   = 1
          speed              = "10G"
          switch_peer        = "second"
        }
      }
    }
  }
}