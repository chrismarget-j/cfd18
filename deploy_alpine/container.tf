module "alpine_s1" {
  source          = "./mod_alpine"
  name            = "alpine"
  container_count = 5
  worker_instance = 1
  image           = data.terraform_remote_state.setup_docker.outputs["image_ids"]["alpine"]
  network_id      = local.network_name
  providers = {
    docker = docker.s1
  }
}

module "alpine_s2" {
  source          = "./mod_alpine"
  name            = "alpine"
  container_count = 5
  worker_instance = 2
  image           = data.terraform_remote_state.setup_docker.outputs["image_ids"]["alpine"]
  network_id      = local.network_name
  providers = {
    docker = docker.s2
  }
}

module "alpine_s3" {
  source          = "./mod_alpine"
  name            = "alpine"
  container_count = 5
  worker_instance = 3
  image           = data.terraform_remote_state.setup_docker.outputs["image_ids"]["alpine"]
  network_id      = local.network_name
  providers = {
    docker = docker.s3
  }
}
