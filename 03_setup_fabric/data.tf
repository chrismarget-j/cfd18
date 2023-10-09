data "terraform_remote_state" "setup_docker" {
  backend = "local"
  config = {
    path = "../01_setup_docker/terraform.tfstate"
  }
}