terraform {
  required_providers {
    apstra = {
      source  = "Juniper/apstra"
      version = "0.37.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "apstra" {
  tls_validation_disabled = true
  blueprint_mutex_enabled = false
}

provider "docker" {
  host = "tcp://s4:2375"
}
