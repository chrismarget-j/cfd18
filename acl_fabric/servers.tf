data "apstra_datacenter_system" "rack_a1_leaf1" {
  blueprint_id = apstra_datacenter_blueprint.cfd_18.id
  name         = "rack_a_001_leaf1"
}

data "apstra_datacenter_system" "rack_a1_leaf2" {
  blueprint_id = apstra_datacenter_blueprint.cfd_18.id
  name         = "rack_a_001_leaf2"
}

data "apstra_datacenter_system" "rack_b1_leaf1" {
  blueprint_id = apstra_datacenter_blueprint.cfd_18.id
  name         = "rack_b_001_leaf1"
}

resource "apstra_datacenter_generic_system" "s1" {
  blueprint_id = apstra_datacenter_blueprint.cfd_18.id
  name         = "S1"
  tags         = ["S1"]
  links = [
    {
      tags                          = ["S1"]
      target_switch_id              = data.apstra_datacenter_system.rack_a1_leaf1.attributes.id
      target_switch_if_name         = "ge-0/0/3"
      target_switch_if_transform_id = 1
    },
  ]
}

resource "apstra_datacenter_generic_system" "s2" {
  blueprint_id = apstra_datacenter_blueprint.cfd_18.id
  name         = "S2"
  tags         = ["S2"]
  links = [
    {
      tags                          = ["S2"]
      target_switch_id              = data.apstra_datacenter_system.rack_a1_leaf2.attributes.id
      target_switch_if_name         = "ge-0/0/3"
      target_switch_if_transform_id = 1
    },
  ]
}

resource "apstra_datacenter_generic_system" "s3" {
  blueprint_id = apstra_datacenter_blueprint.cfd_18.id
  name         = "S3"
  tags         = ["S3"]
  links = [
    {
      tags                          = ["S3"]
      target_switch_id              = data.apstra_datacenter_system.rack_b1_leaf1.attributes.id
      target_switch_if_name         = "ge-0/0/2"
      target_switch_if_transform_id = 1
    },
  ]
}

resource "apstra_datacenter_generic_system" "s4" {
  blueprint_id = apstra_datacenter_blueprint.cfd_18.id
  name         = "S4"
  tags         = ["S4"]
  links = [
    {
      tags                          = ["S4"]
      target_switch_id              = data.apstra_datacenter_system.rack_a1_leaf1.attributes.id
      target_switch_if_name         = "ge-0/0/2"
      target_switch_if_transform_id = 1
    },
    {
      tags                          = ["S4"]
      target_switch_id              = data.apstra_datacenter_system.rack_a1_leaf2.attributes.id
      target_switch_if_name         = "ge-0/0/2"
      target_switch_if_transform_id = 1
    },
  ]
}
