module "lb_net" {
  source          = "../modules/mod_apstra_network"
  blueprint_id    = apstra_datacenter_blueprint.cfd_18.id
  name            = "services"
  routing_zone_id = apstra_datacenter_routing_zone.cfd_18.id
}

data "apstra_datacenter_interfaces_by_link_tag" "lb" {
  blueprint_id = apstra_datacenter_blueprint.cfd_18.id
  tags         = ["S4", local.lb_interface]
  depends_on   = [apstra_datacenter_generic_system.s4]
}

resource "apstra_datacenter_connectivity_template_assignment" "lb" {
  blueprint_id              = apstra_datacenter_blueprint.cfd_18.id
  application_point_id      = one(data.apstra_datacenter_interfaces_by_link_tag.lb.ids)
  connectivity_template_ids = [module.lb_net.ct_tagged]
}

resource "null_resource" "lb_setup" {
  triggers = {
    vlan = module.lb_net.vlan_id
    intf = "${local.lb_interface}.${module.lb_net.vlan_id}"
  }

  connection {
    type        = "ssh"
    user        = "admin"
    host        = "s4"
    private_key = file("../.ssh_key")
  }

  provisioner "file" {
    source      = "haproxy"
    destination = "/home/admin"
  }

  provisioner "remote-exec" {
    inline = flatten([
      "mkdir -p /tmp/terraform; cp /tmp/terraform_*.sh /tmp/terraform",
      "id > /tmp/id",
      "(cd $HOME/haproxy; docker build -t my-haproxy .)",
      "if ! sudo ip link add link ${local.lb_interface} name ${self.triggers["intf"]} type vlan id ${self.triggers["vlan"]}; then :; fi",
      "if ! sudo ip link set dev ${local.lb_interface} up; then :; fi",
      "if ! sudo ip link set dev ${self.triggers["intf"]} up; then :; fi",
      "if ! sudo ip addr add ${cidrhost(module.lb_net.subnet, 10)}/${split("/", module.lb_net.subnet)[1]} dev ${self.triggers["intf"]}; then :; fi",
      [for i in apstra_ipv4_pool.app.subnets :
        "if ! sudo ip route add ${i.network} via ${cidrhost(module.lb_net.subnet, 1)}; then :; fi"
      ],
      "sudo apt-get update -y",
      "sudo apt-get install -y --no-install-recommends haproxy",
      #      "echo 7 >> /tmp/log",
      #      "echo \"127.0.0.1 ${each.key}\" | sudo tee -a /etc/hosts",
      #      "sudo hostname ${each.key}",
      #      "sudo apt-get install -y apt-transport-https software-properties-common",
      #      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      #      "sudo add-apt-repository -y 'deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable'",
      #      "sudo apt update -q",
      #      "sudo apt-cache policy docker-ce",
      #      "sudo apt-get install -y -q docker-ce",
      #      "sudo usermod -aG docker ${local.username}",
    ])
  }
  #  provisioner "remote-exec" {
  #    when = "destroy"
  #    inline = [
  #      "ip link del dev ${self.triggers["intf"]}",
  #    ]
  #  }
}

data "docker_image" "haproxy" {
  name       = "my-haproxy"
  depends_on = [null_resource.lb_setup]
}

resource "docker_container" "haproxy" {
  image      = data.docker_image.haproxy.id
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
