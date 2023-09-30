data "terraform_remote_state" "fabric_setup" {
  backend = "local"
  config = {
    path = "../fabric_setup/terraform.tfstate"
  }
}

data "terraform_remote_state" "setup_docker" {
  backend = "local"
  config = {
    path = "../setup_docker/terraform.tfstate"
  }
}
