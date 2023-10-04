resource "apstra_ipv4_pool" "app" {
  name = "CFD 18 Applications IPv4 Pool"
  subnets = [ for i in local.workload_address_ranges : { network = i }]
#  subnets = [
#    { network = local.workload_address_pool },
#  ]
}