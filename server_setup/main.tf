locals {
  servers  = toset(["s1", "s2", "s3", "s4"])
  username = "admin"
}

data "external" "server_ip" {
  for_each = local.servers
  program = [
    "sh", "-c", "host ${each.key} | awk '{print \"{\\\"ip\\\":\\\"\"$NF\"\\\"}\"}'"
  ]
}

resource "null_resource" "install_docker" {
  for_each = local.servers
  triggers = {
    server_ip = data.external.server_ip[each.key].result.ip
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = local.username
      host        = each.key
      private_key = file(".ssh_key")
    }

    inline = [
      "echo \"127.0.0.1 ${each.key}\" | sudo tee -a /etc/hosts",
      "sudo hostname ${each.key}",
      "sudo apt-get install -y apt-transport-https software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository -y 'deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable'",
      "sudo apt update -q",
      "sudo apt-cache policy docker-ce",
      "sudo apt-get install -y -q docker-ce",
      "sudo usermod -aG docker ${local.username}",
    ]
  }
}
