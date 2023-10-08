locals {
  worker_images = {
    nginx = "nginx:1.25.2",
  }

}

module "docker_image_s1" {
  source   = "./mod_load_images"
  hostname = "s1"
  images   = local.worker_images
}

module "docker_image_s2" {
  source   = "./mod_load_images"
  hostname = "s2"
  images   = local.worker_images
}

module "docker_image_s3" {
  source   = "./mod_load_images"
  hostname = "s3"
  images   = local.worker_images
}

module "docker_image_s4" {
  source   = "./mod_load_images"
  hostname = "s4"
  images   = {vyos = "vyos/image:1.3"}
}
