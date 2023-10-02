data "apstra_datacenter_system" "rack_1_leaf" {
  blueprint_id = apstra_datacenter_blueprint.cfd_18.id
  name         = "rack_001_leaf1"
}

data "apstra_datacenter_system" "rack_2_leaf" {
  blueprint_id = apstra_datacenter_blueprint.cfd_18.id
  name         = "rack_002_leaf1"
}

data "apstra_datacenter_system" "rack_3_leaf" {
  blueprint_id = apstra_datacenter_blueprint.cfd_18.id
  name         = "rack_003_leaf1"
}

resource "apstra_datacenter_generic_system" "s1" {
  blueprint_id = apstra_datacenter_blueprint.cfd_18.id
  name         = "S1"
  tags         = ["S1"]
  links = [
    {
      tags                          = ["S1", "docker"]
      target_switch_id              = data.apstra_datacenter_system.rack_1_leaf.attributes.id
      target_switch_if_name         = "ge-0/0/3"
      target_switch_if_transform_id = 1
    },
  ]
  depends_on = [apstra_datacenter_device_allocation.each]
}

resource "apstra_datacenter_generic_system" "s2" {
  blueprint_id = apstra_datacenter_blueprint.cfd_18.id
  name         = "S2"
  tags         = ["S2"]
  links = [
    {
      tags                          = ["S2", "docker"]
      target_switch_id              = data.apstra_datacenter_system.rack_2_leaf.attributes.id
      target_switch_if_name         = "ge-0/0/3"
      target_switch_if_transform_id = 1
    },
  ]
  depends_on = [apstra_datacenter_device_allocation.each]
}

resource "apstra_datacenter_generic_system" "s3" {
  blueprint_id = apstra_datacenter_blueprint.cfd_18.id
  name         = "S3"
  tags         = ["S3"]
  links = [
    {
      tags                          = ["S3", "docker"]
      target_switch_id              = data.apstra_datacenter_system.rack_3_leaf.attributes.id
      target_switch_if_name         = "ge-0/0/2"
      target_switch_if_transform_id = 1
    },
  ]
  depends_on = [apstra_datacenter_device_allocation.each]
}

resource "apstra_datacenter_generic_system" "s4" {
  blueprint_id = apstra_datacenter_blueprint.cfd_18.id
  name         = "S4"
  tags         = ["S4"]
  external     = true
  links = [
    {
      tags                          = ["S4", "eth1"]
      target_switch_id              = data.apstra_datacenter_system.rack_1_leaf.attributes.id
      target_switch_if_name         = "ge-0/0/2"
      target_switch_if_transform_id = 1
    },
    {
      tags                          = ["S4", "eth2"]
      target_switch_id              = data.apstra_datacenter_system.rack_2_leaf.attributes.id
      target_switch_if_name         = "ge-0/0/2"
      target_switch_if_transform_id = 1
    },
  ]
  depends_on = [apstra_datacenter_device_allocation.each]
}
