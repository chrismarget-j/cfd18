locals {
  lb_servers = merge(
    { for i in module.container_s1.ip_addresses : "s1-${replace(i, ".", "_")}" => i },
    { for i in module.container_s2.ip_addresses : "s2-${replace(i, ".", "_")}" => i },
    { for i in module.container_s3.ip_addresses : "s3-${replace(i, ".", "_")}" => i },
  )
}

resource "haproxy_server" "app" {
  for_each    = local.lb_servers
  name        = each.key
  port        = 80
  address     = each.value
  parent_name = "app"
  parent_type = "backend"
  check       = true
}
