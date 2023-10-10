module "apstra_network" {
  source = "../modules/mod_apstra_network_on_worker_nodes"
  name = local.container_name
  blueprint_id = data.terraform_remote_state.setup_fabric.outputs["blueprint_id"]
  routing_zone_id = data.terraform_remote_state.setup_fabric.outputs["routing_zone_id"]
  providers = { apstra = apstra }
}

module "s1_network" {
  providers = { docker = docker.s1 }
  source = "../modules/mod_network_docker"
  name   = local.container_name
  subnet = module.apstra_network.subnet
  vlan   = module.apstra_network.vlan_id
  interface = local.docker_interface
  worker_instance = 1
}

module "s2_network" {
  providers = { docker = docker.s2 }
  source = "../modules/mod_network_docker"
  name   = local.container_name
  subnet = module.apstra_network.subnet
  vlan   = module.apstra_network.vlan_id
  interface = local.docker_interface
  worker_instance = 2
}

module "s3_network" {
  providers = { docker = docker.s3 }
  source = "../modules/mod_network_docker"
  name   = local.container_name
  subnet = module.apstra_network.subnet
  vlan   = module.apstra_network.vlan_id
  interface = local.docker_interface
  worker_instance = 3
}
