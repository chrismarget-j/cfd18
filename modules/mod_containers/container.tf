resource "docker_container" "o" {
  count = floor(var.container_count / 3) + (var.container_count % 3 >= var.worker_instance ? 1 : 0)
  image = var.image
  name  = "${var.name}-${count.index * 3 + var.worker_instance}"
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
}
