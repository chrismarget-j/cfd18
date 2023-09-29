locals {
  s1_count = (floor(local.webserver_count / 3)) + (local.webserver_count % 3 >= 1 ? 1 : 0)
  s2_count = (floor(local.webserver_count / 3)) + (local.webserver_count % 3 >= 2 ? 1 : 0)
  s3_count = (floor(local.webserver_count / 3))
}


#resource "docker_container" "alpine_s1" {
#  count      = local.s1_count
#  provider   = docker.s1
#  image      = data.terraform_remote_state.worker_setup.outputs.image_ids["alpine"]
#  name       = "alpine-${count.index * 3 + 1}"
#  entrypoint = ["sleep", "3600"]
#  networks_advanced {
#    name = docker_network.web_s1.id
#  }
#}
#
#resource "docker_container" "alpine_s2" {
#  count      = local.s2_count
#  provider   = docker.s2
#  image      = data.terraform_remote_state.worker_setup.outputs.image_ids["alpine"]
#  name       = "alpine-${count.index * 3 + 2}"
#  entrypoint = ["sleep", "3600"]
#  networks_advanced {
#    name = docker_network.web_s2.id
#  }
#}
#
#resource "docker_container" "alpine_s3" {
#  count      = local.s3_count
#  provider   = docker.s3
#  image      = data.terraform_remote_state.worker_setup.outputs.image_ids["alpine"]
#  name       = "alpine-${count.index * 3 + 3}"
#  entrypoint = ["sleep", "3600"]
#  networks_advanced {
#    name = docker_network.web_s3.id
#  }
#}
#
##resource "docker_container" "nginx_s2" {
##  count    = local.s2_count
##  provider = docker.s2
##  image    = docker_image.nginx_s2.image_id
##  name     = "webserver-${count.index * 3 + 2}"
##  ports {
##    internal = 80
##    external = 8000 + count.index
##  }
##}
#
##resource "docker_container" "nginx_s3" {
##  count    = local.s3_count
##  provider = docker.s3
##  image    = docker_image.nginx_s3.image_id
##  name     = "webserver-${count.index * 3 + 3}"
##  ports {
##    internal = 80
##    external = 8000 + count.index
##  }
##}
#