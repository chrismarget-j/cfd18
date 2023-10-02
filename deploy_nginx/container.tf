module "container_s1" {
  source          = "../modules/mod_containers"
  name            = local.container_name
  container_count = 5
  worker_instance = 1
  image           = data.terraform_remote_state.setup_docker.outputs["image_ids"]["nginx"]
  network_id      = local.container_name
  providers = { docker = docker.s1 }
  depends_on = [module.s1_network]
}

module "container_s2" {
  source          = "../modules/mod_containers"
  name            = local.container_name
  container_count = 5
  worker_instance = 2
  image           = data.terraform_remote_state.setup_docker.outputs["image_ids"]["nginx"]
  network_id      = local.container_name
  providers = { docker = docker.s2 }
  depends_on = [module.s2_network]
}

module "container_s3" {
  source          = "../modules/mod_containers"
  name            = local.container_name
  container_count = 5
  worker_instance = 3
  image           = data.terraform_remote_state.setup_docker.outputs["image_ids"]["nginx"]
  network_id      = local.container_name
  providers = { docker = docker.s3 }
  depends_on = [module.s3_network]
}
