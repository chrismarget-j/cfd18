module "apstra_network" {
  source = "./mod_network_apstra"
  name = "web"
  blueprint_id = data.terraform_remote_state.fabric_setup.outputs["blueprint_id"]
  routing_zone_id = data.terraform_remote_state.fabric_setup.outputs["routing_zone_id"]
  providers = { apstra = apstra }
}

module "s1_network" {
  source = "./mod_network_docker"
  name   = "web"
  subnet = module.apstra_network.subnet
  vlan   = module.apstra_network.vlan_id
  worker_instance = 1
}

module "s2_network" {
  source = "./mod_network_docker"
  name   = "web"
  subnet = module.apstra_network.subnet
  vlan   = module.apstra_network.vlan_id
  worker_instance = 2
}

module "s3_network" {
  source = "./mod_network_docker"
  name   = "web"
  subnet = module.apstra_network.subnet
  vlan   = module.apstra_network.vlan_id
  worker_instance = 3
}


#}
#
#resource "docker_network" "web_s1" {
#  provider = docker.s1
#  name     = "web"
#  driver   = "macvlan"
#  ipam_config {
#    subnet   = apstra_datacenter_virtual_network.web.ipv4_subnet
#    gateway  = apstra_datacenter_virtual_network.web.ipv4_virtual_gateway
#    ip_range = cidrsubnet(apstra_datacenter_virtual_network.web.ipv4_subnet, 4, 1)
#  }
#  options = {
#    subnet  = apstra_datacenter_virtual_network.web.ipv4_subnet
#    gateway = apstra_datacenter_virtual_network.web.ipv4_virtual_gateway
#    parent  = "${local.interface}.${local.vlan}"
#  }
#  connection {
#    type        = "ssh"
#    user        = "admin"
#    host        = "s1"
#    private_key = file("../.ssh_key")
#  }
#  provisioner "remote-exec" {
#    inline = [
#      "sudo ip link add link ${local.interface} name ${local.interface}.${local.vlan} type vlan id ${local.vlan}"
#    ]
#  }
#  provisioner "remote-exec" {
#    when = destroy
#    inline = [
#      "sudo ip link del ${self.options["parent"]}"
#    ]
#  }
#  depends_on = [null_resource.vlan_change_trigger]
#}
#
#resource "docker_network" "web_s2" {
#  provider = docker.s2
#  name     = "web"
#  driver   = "macvlan"
#  ipam_config {
#    subnet   = apstra_datacenter_virtual_network.web.ipv4_subnet
#    gateway  = apstra_datacenter_virtual_network.web.ipv4_virtual_gateway
#    ip_range = cidrsubnet(apstra_datacenter_virtual_network.web.ipv4_subnet, 4, 2)
#  }
#  options = {
#    subnet  = apstra_datacenter_virtual_network.web.ipv4_subnet
#    gateway = apstra_datacenter_virtual_network.web.ipv4_virtual_gateway
#    parent  = "${local.interface}.${local.vlan}"
#  }
#  connection {
#    type        = "ssh"
#    user        = "admin"
#    host        = "s2"
#    private_key = file("../.ssh_key")
#  }
#  provisioner "remote-exec" {
#    inline = [
#      "sudo ip link add link ${local.interface} name ${local.interface}.${local.vlan} type vlan id ${local.vlan}"
#    ]
#  }
#  provisioner "remote-exec" {
#    when = destroy
#    inline = [
#      "sudo ip link del ${self.options["parent"]}"
#    ]
#  }
#  depends_on = [null_resource.vlan_change_trigger]
#}
#
#resource "docker_network" "web_s3" {
#  provider = docker.s3
#  name     = "web"
#  driver   = "macvlan"
#  ipam_config {
#    subnet   = apstra_datacenter_virtual_network.web.ipv4_subnet
#    gateway  = apstra_datacenter_virtual_network.web.ipv4_virtual_gateway
#    ip_range = cidrsubnet(apstra_datacenter_virtual_network.web.ipv4_subnet, 4, 3)
#  }
#  options = {
#    subnet  = apstra_datacenter_virtual_network.web.ipv4_subnet
#    gateway = apstra_datacenter_virtual_network.web.ipv4_virtual_gateway
#    parent  = "${local.interface}.${local.vlan}"
#  }
#  connection {
#    type        = "ssh"
#    user        = "admin"
#    host        = "s3"
#    private_key = file("../.ssh_key")
#  }
#  provisioner "remote-exec" {
#    inline = [
#      "sudo ip link add link ${local.interface} name ${local.interface}.${local.vlan} type vlan id ${local.vlan}"
#    ]
#  }
#  provisioner "remote-exec" {
#    when = destroy
#    inline = [
#      "sudo ip link del ${self.options["parent"]}"
#    ]
#  }
#  depends_on = [null_resource.vlan_change_trigger]
#}
