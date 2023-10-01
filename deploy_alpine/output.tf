output "ip_addresses" {
  value = sort(concat(
    module.alpine_s1.ip_addresses,
    module.alpine_s2.ip_addresses,
    module.alpine_s3.ip_addresses,
  ))
}