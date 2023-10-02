output "ip_addresses" {
  value = [ for i in docker_container.o : one(i.network_data).ip_address ]
}
