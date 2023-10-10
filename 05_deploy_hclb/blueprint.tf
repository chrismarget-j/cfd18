resource "apstra_blueprint_deployment" "o" {
  blueprint_id    = data.terraform_remote_state.setup_fabric.outputs["blueprint_id"]

  depends_on = [
    apstra_datacenter_connectivity_template_assignment.lb,
    apstra_datacenter_connectivity_template_assignment.svi_bgp,
  ]
}
