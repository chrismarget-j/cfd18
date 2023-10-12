variable "app_name" {
  type    = string
  default = "cfd_app"
}

variable "app_prefixes" {
  type    = list(string)
  default = ["10.50.0.0/16", "10.51.0.0/16"]
}

variable "app_worker_count" {
  type    = number
  default = 3
}
