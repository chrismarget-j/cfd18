resource "docker_container" "alpine" {
  count      = floor(var.container_count / 3) + (var.container_count % 3 >= var.worker_instance ? 1 : 0)
  image      = var.image
  name       = "${var.name}-${count.index * 3 + 1}"
  entrypoint = ["sleep", "3600"]
  networks_advanced {
    name = var.network_id
  }
}
