variable "blueprint_id" {
  type = string
}

variable "vlan_id" {
  type     = number
  default = null
}

variable "routing_zone_id" {
  type = string
}

variable "name" {
  type = string
}

variable "ipv4_subnet" {
  type = string
  default = null
}