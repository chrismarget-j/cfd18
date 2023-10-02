module "lb_net" {
  source          = "../modules/mod_apstra_network"
  blueprint_id    = apstra_datacenter_blueprint.cfd_18.id
  name            = "services"
  routing_zone_id = apstra_datacenter_routing_zone.cfd_18.id
}

data "apstra_datacenter_interfaces_by_link_tag" "lb" {
  blueprint_id = apstra_datacenter_blueprint.cfd_18.id
  tags         = ["S4", "eth1"]
}

resource "apstra_datacenter_connectivity_template_assignment" "lb" {
  blueprint_id              = apstra_datacenter_blueprint.cfd_18.id
  application_point_id      = one(data.apstra_datacenter_interfaces_by_link_tag.lb.ids)
  connectivity_template_ids = [module.lb_net.ct_tagged]
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

  provisioner "file" {
    source = "haproxy"
    destination = "/home/admin"
  }

  provisioner "remote-exec" {
    inline = flatten([
      "(cd $HOME/haproxy; docker build -t my-haproxy .)",
      "if ! ip link add link eth1 name ${self.triggers["intf"]} type vlan id ${self.triggers["vlan"]}; then :; fi",
      "if ! ip link set dev eth1.${module.lb_net.vlan_id} up; then :; fi",
      "if ! ip addr add ${cidrhost(module.lb_net.subnet, 10)}/${split("/", module.lb_net.subnet)[1]} dev eth1.${module.lb_net.vlan_id}; then :; fi",
      [for i in apstra_ipv4_pool.app.subnets :
        "if ! ip route add ${i.network} via ${cidrhost(module.lb_net.subnet, 1)}; then :; fi"
      ],
      "sudo apt-get update -y",
      "sudo apt-get install -y haproxy",
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