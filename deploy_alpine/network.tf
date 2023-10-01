module "apstra_network" {
  source = "./mod_network_apstra"
  name = "web"
  blueprint_id = data.terraform_remote_state.setup_fabric.outputs["blueprint_id"]
  routing_zone_id = data.terraform_remote_state.setup_fabric.outputs["routing_zone_id"]
  providers = { apstra = apstra }
}

module "s1_network" {
  source = "./mod_network_docker"
  name   = "web"
  subnet = module.apstra_network.subnet
  vlan   = module.apstra_network.vlan_id
  worker_instance = 1
}

module "s2_network" {
  source = "./mod_network_docker"
  name   = "web"
  subnet = module.apstra_network.subnet
  vlan   = module.apstra_network.vlan_id
  worker_instance = 2
}

module "s3_network" {
  source = "./mod_network_docker"
  name   = "web"
  subnet = module.apstra_network.subnet
  vlan   = module.apstra_network.vlan_id
  worker_instance = 3
}
