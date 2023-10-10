locals {
  container_name = "my_application"
  webserver_count = 3
  app_prefixes = [
    "10.50.0.0/16",
    "10.60.0.0/16",
  ]
  docker_interface = "eth1"
}
