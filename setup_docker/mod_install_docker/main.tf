locals {
  username = "admin"
}

data "external" "server_ip" {
  program = [
    "sh", "-c", "host ${var.hostname} | awk '{print \"{\\\"ip\\\":\\\"\"$NF\"\\\"}\"}'"
  ]
}

resource "null_resource" "install_docker" {
  triggers = {
    server_ip = data.external.server_ip.result.ip
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = local.username
      host        = var.hostname
      private_key = file("../.ssh_key")
    }

    inline = [
      "echo \"127.0.0.1 ${var.hostname}\" | sudo tee -a /etc/hosts",
      "sudo hostname ${var.hostname}",
      "ip -o link list | grep @eth1 | awk '{print $2}' | sed 's/@.*//' | xargs -rn 1 sudo ip link del",
      "ip -o link list | grep @bond0 | awk '{print $2}' | sed 's/@.*//' | xargs -rn 1 sudo ip link del",
      "ip -o link list | grep ' bond0:' | awk '{print $2}' | sed 's/://' | xargs -rn 1 sudo ip link del",
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
