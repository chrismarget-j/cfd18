terraform {
  required_providers {
    apstra = {
      source  = "Juniper/apstra"
      version = "0.36.1"
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
  alias = "s1"
  host = "ssh://admin@s1"
}

provider "docker" {
  alias = "s2"
  host = "ssh://admin@s2"
}

provider "docker" {
  alias = "s3"
  host = "ssh://admin@s3"
}
