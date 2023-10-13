variable "app_name" {
  type    = string
#  default = "cfd"
}

variable "app_prefixes" {
  type    = list(string)
#  default = ["10.40.0.0/16", "10.61.0.0/16"]
}

variable "app_worker_count" {
  type    = number
#  default = 3
}
