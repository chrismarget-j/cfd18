resource "apstra_ipv4_pool" "app" {
  name = "Application IPv4 Pool"
  subnets = [
    { network = "172.31.0.0/16" }
  ]
}