terraform {
  required_providers {
    apstra = {
      source  = "Juniper/apstra"
      version = "0.35.0"
    }
  }
}

provider "apstra" {
  url                     = "https://admin:SnappyLark5-@18.181.146.179:43259"
  tls_validation_disabled = true
  blueprint_mutex_enabled = false
}
