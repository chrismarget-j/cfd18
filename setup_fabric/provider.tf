terraform {
  required_providers {
    apstra = {
      source  = "Juniper/apstra"
      version = "0.36.1"
    }
  }
}

provider "apstra" {
  tls_validation_disabled = true
  blueprint_mutex_enabled = false
}
