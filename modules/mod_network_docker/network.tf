resource "null_resource" "vlan_change_trigger" {
  triggers = {
    vlan = var.vlan
  }
}

resource "docker_network" "o" {
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
    parent  = "${var.interface}.${var.vlan}"
  }
  depends_on = [null_resource.vlan_change_trigger]
}
