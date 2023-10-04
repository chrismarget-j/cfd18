resource "docker_container" "o" {
  count = floor(var.container_count / 3) + (var.container_count % 3 >= var.worker_instance ? 1 : 0)
  image = var.image
  name  = "${var.name}-${count.index * 3 + 1}"
  networks_advanced {
    name = var.network_id
  }
  dynamic "volumes" {
    for_each = var.files
    content {
      host_path      = volumes.key
      container_path = volumes.value
    }
  }
#  volumes {
#    host_path      = "/tmp/99-random-color.sh"
#    container_path = "/docker-entrypoint.d/99-random-color.sh"
#  }
}
