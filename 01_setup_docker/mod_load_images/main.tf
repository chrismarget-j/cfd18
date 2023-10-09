resource "docker_image" "o" {
  connection {
    type        = "ssh"
    user        = "admin"
    host        = var.hostname
    private_key = file("../.ssh_key")
  }

  provisioner "file" {
    source      = "99-random-color.sh"
    destination = "99-random-color.sh"
  }

  provisioner "file" {
    source      = "default.conf"
    destination = "default.conf"
  }

  provisioner "remote-exec" {
    inline = ["chmod 755 99-random-color.sh"]
  }

  for_each     = var.images
  provider     = docker
  name         = each.value
  keep_locally = true
}
