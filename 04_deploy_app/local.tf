locals {
  container_name   = var.app_name
  webserver_count  = var.app_worker_count
  app_prefixes     = var.app_prefixes
  docker_interface = "eth1"
}
