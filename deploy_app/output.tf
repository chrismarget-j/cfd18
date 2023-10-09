output "ip_addresses" {
  value = local.container_ips
}

output "app_subnet" {
  value = module.apstra_network.subnet
}

output "virtual_network_id" {
  value = module.apstra_network.virtual_network_id
}
