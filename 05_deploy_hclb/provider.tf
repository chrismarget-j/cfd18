terraform {
  required_providers {
    apstra = {
      source  = "Juniper/apstra"
      version = "0.37.0"
    }
    aws = {
      source = "hashicorp/aws"
      version = "5.20.0"
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

provider "aws" {
  region = "us-east-1"
}

provider "docker" {
  host  = "tcp://${local.docker_host}:2375"
}
