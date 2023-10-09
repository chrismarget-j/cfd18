resource "apstra_blueprint_deployment" "cfd_18" {
  blueprint_id = data.terraform_remote_state.setup_fabric.outputs["blueprint_id"]
  depends_on = [
    module.apstra_network,
    apstra_datacenter_resource_pool_allocation.cfd_apps,
  ]
  comment = "Network deployment by Terraform {{.TerraformVersion}}, Apstra provider {{.ProviderVersion}}, User $USER."
}
