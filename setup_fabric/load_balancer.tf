module "lb_net" {
  source          = "../modules/mod_apstra_network"
  blueprint_id    = apstra_datacenter_blueprint.cfd_18.id
  name            = local.lb_net_name
  routing_zone_id = apstra_datacenter_routing_zone.cfd_18.id
  ipv4_subnet     = local.lb_subnet
}

data "apstra_datacenter_interfaces_by_link_tag" "lb" {
  blueprint_id = apstra_datacenter_blueprint.cfd_18.id
  tags         = ["S4", "eth1"]
  depends_on   = [apstra_datacenter_generic_system.s4]
}

resource "apstra_datacenter_connectivity_template_assignment" "lb" {
  blueprint_id              = apstra_datacenter_blueprint.cfd_18.id
  application_point_id      = one(data.apstra_datacenter_interfaces_by_link_tag.lb.ids)
  connectivity_template_ids = [module.lb_net.ct_tagged]
}

locals {
  haproxy_build_dir = "${path.module}/haproxy"
}

resource "docker_image" "lb" {
  name = "haproxy"
  build {
    context = local.haproxy_build_dir
  }
  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset(local.haproxy_build_dir, "*") : filesha1("${local.haproxy_build_dir}/${f}")]))
  }
}

resource "null_resource" "lb_setup" {
  triggers = {
    vlan = module.lb_net.vlan_id
    intf = "eth1.${module.lb_net.vlan_id}"
  }

  connection {
    type        = "ssh"
    user        = "admin"
    host        = "s4"
    private_key = file("../.ssh_key")
  }

  provisioner "remote-exec" {
    inline = flatten([
      "if ! sudo ip link add link eth1 name ${self.triggers["intf"]} type vlan id ${self.triggers["vlan"]}; then :; fi",
      "if ! sudo ip link set dev eth1 up; then :; fi",
      "if ! sudo ip link set dev ${self.triggers["intf"]} up; then :; fi",
      "if ! sudo ip addr add ${cidrhost(module.lb_net.subnet, 10)}/${split("/", module.lb_net.subnet)[1]} dev ${self.triggers["intf"]}; then :; fi",
      [for i in apstra_ipv4_pool.app.subnets :
        "if ! sudo ip route add ${i.network} via ${cidrhost(module.lb_net.subnet, 1)}; then :; fi"
      ],
    ])
  }

  provisioner "remote-exec" {
    when   = destroy
    inline = ["if ! sudo ip link del dev ${self.triggers["intf"]}; then :; fi"]
  }
}

#data "docker_image" "haproxy" {
#  name       = "my-haproxy"
#  depends_on = [null_resource.lb_setup]
#}

resource "docker_container" "haproxy" {
  image      = docker_image.lb.image_id
  name       = "haproxy"
  entrypoint = ["/usr/local/sbin/haproxy", "-f", "/etc/haproxy/haproxy.cfg"]

  ports {
    internal = 80
    external = 80
    ip       = "0.0.0.0"
  }

  ports {
    internal = 5555
    external = 5555
    ip       = "0.0.0.0"
  }

  ports {
    internal = 8404
    external = 8404
    ip       = "0.0.0.0"
  }

  depends_on = [null_resource.lb_setup]
}
