resource "docker_image" "nginx_s1" {
  provider = docker.s1
  name         = "nginx:1.25.2"
  keep_locally = true
}

resource "docker_image" "nginx_s2" {
  provider = docker.s2
  name         = "nginx:1.25.2"
  keep_locally = true
}

resource "docker_image" "nginx_s3" {
  provider = docker.s3
  name         = "nginx:1.25.2"
  keep_locally = true
}
