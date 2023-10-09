terraform {
  required_providers {
    apstra = {
      source  = "Juniper/apstra"
      version = "0.36.1"
    }
    aws = {
      source = "hashicorp/aws"
      version = "5.20.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
#    haproxy = {
#      source  = "SepehrImanian/haproxy"
#      version = "0.0.7"
#    }
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

#provider "haproxy" {
#  url         = "http://s4:5555"
#  username    = "admin"
#  password    = "mypassword"
#}
