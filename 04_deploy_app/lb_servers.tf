resource "haproxy_server" "app" {
  count       = local.webserver_count
  name        = "${local.container_name}-${count.index}-${local.container_ips[count.index]}"
  port        = 80
  address     = local.container_ips[count.index]
  parent_name = "app"
  parent_type = "backend"
  check       = true
}
