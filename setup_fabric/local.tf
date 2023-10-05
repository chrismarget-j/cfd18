locals {
  workload_address_ranges = [
    "172.20.0.0/16",
    "172.30.0.0/16",
  ]
  routing_zone_name = "cfd_18"
  lb_net_name       = "lb_net"
  lb_subnet         = "172.31.255.0/24"
}