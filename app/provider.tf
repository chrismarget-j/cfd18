terraform {
  required_providers {
    apstra = {
      source  = "Juniper/apstra"
      version = "0.36.1"
    }
  }
}

provider "apstra" {
  blueprint_mutex_enabled = false
  tls_validation_disabled = true
}
