locals {
  images = {
    nginx  = "nginx:1.25.2"
    alpine = "alpine:3.18.4"
  }
}

resource "docker_image" "s1_images" {
  for_each     = local.images
  provider     = docker.s1
  name         = each.value
  keep_locally = true
}

resource "docker_image" "s2_images" {
  for_each     = local.images
  provider     = docker.s2
  name         = each.value
  keep_locally = true
}

resource "docker_image" "s3_images" {
  for_each     = local.images
  provider     = docker.s3
  name         = each.value
  keep_locally = true
}
