resource "apstra_ipv4_pool" "app" {
  name = "Application IPv4 Pool"
  subnets = [
    { network = local.workload_address_pool },
  ]
}