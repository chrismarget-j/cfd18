module "apstra_network" {
  source = "../modules/mod_apstra_network_on_worker_nodes"
  name = local.container_name
  blueprint_id = data.terraform_remote_state.setup_fabric.outputs["blueprint_id"]
  routing_zone_id = data.terraform_remote_state.setup_fabric.outputs["routing_zone_id"]
  providers = { apstra = apstra }
}

module "s1_network" {
  source = "../modules/mod_network_docker"
  name   = local.container_name
  subnet = module.apstra_network.subnet
  vlan   = module.apstra_network.vlan_id
  worker_instance = 1
}

module "s2_network" {
  source = "../modules/mod_network_docker"
  name   = local.container_name
  subnet = module.apstra_network.subnet
  vlan   = module.apstra_network.vlan_id
  worker_instance = 2
}

module "s3_network" {
  source = "../modules/mod_network_docker"
  name   = local.container_name
  subnet = module.apstra_network.subnet
  vlan   = module.apstra_network.vlan_id
  worker_instance = 3
}

resource "apstra_blueprint_deployment" "cfd_18" {
  blueprint_id = data.terraform_remote_state.setup_fabric.outputs["blueprint_id"]
  depends_on = [ module.apstra_network ]
  comment      = "Network deployment by Terraform {{.TerraformVersion}}, Apstra provider {{.ProviderVersion}}, User $USER."
}