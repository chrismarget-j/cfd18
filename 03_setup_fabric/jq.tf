resource "null_resource" "tf" {
  connection {
    type        = "ssh"
    user        = "admin"
    host        = "s4"
    private_key = file("../.ssh_key")
  }

  provisioner "remote-exec" {
    inline = ["sudo apt-get -y install jq"]
  }
}