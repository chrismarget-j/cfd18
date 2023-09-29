terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  alias = "s1"
  host  = "ssh://admin@s1"
}

provider "docker" {
  alias = "s2"
  host  = "ssh://admin@s2"
}

provider "docker" {
  alias = "s3"
  host  = "ssh://admin@s3"
}
