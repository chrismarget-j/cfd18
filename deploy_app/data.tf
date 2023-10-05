data "terraform_remote_state" "setup_fabric" {
  backend = "local"
  config = {
    path = "../setup_fabric/terraform.tfstate"
  }
}

data "terraform_remote_state" "setup_docker" {
  backend = "local"
  config = {
    path = "../setup_docker/terraform.tfstate"
  }
}
