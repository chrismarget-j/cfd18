output "ip_addresses" {
  value = [ for i in docker_container.alpine : one(i.network_data).ip_address ]
}