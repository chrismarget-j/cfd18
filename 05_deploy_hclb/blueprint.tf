resource "apstra_blueprint_deployment" "a" {
  blueprint_id    = data.terraform_remote_state.setup_fabric.outputs["blueprint_id"]

  depends_on = [
    apstra_datacenter_connectivity_template_assignment.lb,
    apstra_datacenter_connectivity_template_assignment.svi_bgp,
  ]
}

#resource "apstra_blueprint_deployment" "b" {
#  blueprint_id    = data.terraform_remote_state.setup_fabric.outputs["blueprint_id"]
#
#  depends_on = [
#    module.apstra_transit_net,
#    apstra_datacenter_connectivity_template_assignment.lb,
#    apstra_datacenter_connectivity_template_assignment.svi_bgp,
#  ]
#}
