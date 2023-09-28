locals {
  s1_count = (floor(local.webserver_count / 3)) + (local.webserver_count % 3 >= 1 ? 1 : 0)
  s2_count = (floor(local.webserver_count / 3)) + (local.webserver_count % 3 >= 2 ? 1 : 0)
  s3_count = (floor(local.webserver_count / 3))
}

resource "docker_container" "nginx_s1" {
  count    = local.s1_count
  provider = docker.s1
  image    = docker_image.nginx_s1.image_id
  name     = "webserver-${count.index * 3 + 1}"
  ports {
    internal = 80
    external = 8000 + count.index
  }
}

resource "docker_container" "nginx_s2" {
  count    = local.s2_count
  provider = docker.s2
  image    = docker_image.nginx_s2.image_id
  name     = "webserver-${count.index * 3 + 2}"
  ports {
    internal = 80
    external = 8000 + count.index
  }
}

resource "docker_container" "nginx_s3" {
  count    = local.s3_count
  provider = docker.s3
  image    = docker_image.nginx_s3.image_id
  name     = "webserver-${count.index * 3 + 3}"
  ports {
    internal = 80
    external = 8000 + count.index
  }
}
