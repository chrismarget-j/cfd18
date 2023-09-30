resource "null_resource" "vlan_change_trigger" {
  triggers = {
    vlan = var.vlan
  }
}

resource "docker_network" "web_s1" {
  name     = var.name
  driver   = "macvlan"
  ipam_config {
    subnet   = var.subnet
    gateway  = cidrhost(var.subnet, 1)
    ip_range = cidrsubnet(var.subnet, 4, var.worker_instance)
  }
  options = {
    subnet  = var.subnet
    gateway = cidrhost(var.subnet, 1)
    parent  = "${local.interface}.${var.vlan}"
  }
  depends_on = [null_resource.vlan_change_trigger]
}
