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
    haproxy = {
      source  = "SepehrImanian/haproxy"
      version = "0.0.7"
    }
  }
}

provider "apstra" {
  tls_validation_disabled = true
  blueprint_mutex_enabled = false
}

provider "docker" {
  alias = "s1"
  host  = "tcp://s1:2375"
}

provider "docker" {
  alias = "s2"
  host  = "tcp://s2:2375"
}

provider "docker" {
  alias = "s3"
  host  = "tcp://s3:2375"
}

provider "haproxy" {
  url         = "http://s4:5555"
  username    = "admin"
  password    = "mypassword"
}
