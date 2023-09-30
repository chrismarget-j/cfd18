resource "docker_image" "o" {
  for_each     = var.images
  provider     = docker
  name         = each.value
  keep_locally = true
}
