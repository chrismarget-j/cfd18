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
