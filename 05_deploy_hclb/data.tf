data "terraform_remote_state" "deploy_app" {
  backend = "local"
  config = {
    path = "../04_deploy_app/terraform.tfstate"
  }
}

data "terraform_remote_state" "setup_aws" {
  backend = "local"
  config = {
    path = "../02_setup_aws/terraform.tfstate"
  }
}

data "terraform_remote_state" "setup_fabric" {
  backend = "local"
  config = {
    path = "../03_setup_fabric/terraform.tfstate"
  }
}

data "terraform_remote_state" "setup_docker" {
  backend = "local"
  config = {
    path = "../01_setup_docker/terraform.tfstate"
  }
}

data "apstra_datacenter_systems" "leaf_1" {
  blueprint_id = data.terraform_remote_state.setup_fabric.outputs["blueprint_id"]
  filters = [
    {
      label = "cfd_18_rack_001_leaf1"
    }
  ]
}

data "apstra_datacenter_svis_map" "o" {
  blueprint_id = data.terraform_remote_state.setup_fabric.outputs["blueprint_id"]
  depends_on   = [module.apstra_transit_net]
}

resource "null_resource" "pub_ip_script" {
  connection {
    type        = "ssh"
    user        = "admin"
    host        = local.docker_host
    private_key = file("../.ssh_key")
  }

  provisioner "file" {
    source      = "pub_ip.sh"
    destination = "/tmp/pub_ip.sh"
  }

  provisioner "remote-exec" {
    inline = ["chmod 755 /tmp/pub_ip.sh"]
  }
}

data "external" "pub_ip" {
  program    = ["ssh", local.docker_host, "/tmp/pub_ip.sh"]
  depends_on = [null_resource.pub_ip_script]
}

locals {
  #  transit_vn_id = module.apstra_transit_net.id
  leaf_1_id             = one(data.apstra_datacenter_systems.leaf_1.ids)
  leaf_1_svi_ids        = data.apstra_datacenter_svis_map.o.by_system[one(data.apstra_datacenter_systems.leaf_1.ids)]
  leaf_1_transit_svi_id = one([for svi in local.leaf_1_svi_ids : svi.id if svi.virtual_network_id == module.apstra_transit_net.id])
}
#output "svi" { value = data.terraform_remote_state.deploy_app.outputs["virtual_network_id"] }
#output "svi" { value = [for svi in data.apstra_datacenter_svis_map.o.by_system[one(data.apstra_datacenter_systems.leaf_1.ids)] : svi if svi.virtual_network_id == data.terraform_remote_state.deploy_app.outputs["apstra_virtual_network_id"]] }
#output "leaf_1_svi_ids" { value = local.leaf_1_svi_ids}
#output "leaf_1_transit_svi_id" { value = local.leaf_1_transit_svi_id }
