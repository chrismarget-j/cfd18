locals {
  workload_address_ranges = [
#    "172.29.0.0/16",
#    "172.30.0.0/16",
    "172.31.0.0/16", // do not change while haproxy API remains a todo
  ]
  routing_zone_name = "cfd_18"
  lb_net_name = "lb_net"
}