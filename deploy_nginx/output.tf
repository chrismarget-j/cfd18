output "ip_addresses" {
  value = sort(concat(
    module.container_s1.ip_addresses,
    module.container_s2.ip_addresses,
    module.container_s3.ip_addresses,
  ))
}