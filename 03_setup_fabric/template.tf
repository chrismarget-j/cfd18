# Create a template using previously looked-up (data) spine info and previously
# created (resource) rack types.
resource "apstra_template_rack_based" "cfd_18" {
  name                     = "CFD 18 Template"
  asn_allocation_scheme    = "unique"
  overlay_control_protocol = "evpn"
  spine = {
    count             = 2
    logical_device_id = "virtual-7x10-1"
  }
  rack_infos = {
    (apstra_rack_type.rack.id)    = { count = 3 }
  }
}