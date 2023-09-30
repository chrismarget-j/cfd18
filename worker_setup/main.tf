locals {
  worker_nodes = [
    "s1",
    "s2",
    "s3",
  ]
  images = {
    nginx = "nginx:1.25.2",
    alpine = "alpine:3.18.4",
  }
}

module "install_docker" {
  for_each = toset(local.worker_nodes)
  source   = "./mod_install_docker"
  hostname = each.key
}

module "docker_image_s1" {
  source   = "./mod_load_images"
  hostname = "s1"
  images   = local.images
}

module "docker_image_s2" {
  source   = "./mod_load_images"
  hostname = "s2"
  images   = local.images
}

module "docker_image_s3" {
  source   = "./mod_load_images"
  hostname = "s3"
  images   = local.images
}
