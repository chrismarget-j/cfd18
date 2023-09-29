data "terraform_remote_state" "fabric_setup" {
  backend = "local"
  config = {
    path = "../fabric_setup/terraform.tfstate"
  }
}

data "terraform_remote_state" "worker_setup" {
  backend = "local"
  config = {
    path = "../worker_setup/terraform.tfstate"
  }
}

