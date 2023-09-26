resource "apstra_datacenter_blueprint" "cfd_18" {
  name        = "CFD 18"
  template_id = apstra_template_rack_based.cfd_18.id
}
