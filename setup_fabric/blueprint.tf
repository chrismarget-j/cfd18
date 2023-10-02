resource "apstra_datacenter_blueprint" "cfd_18" {
  name        = "CFD 18"
  template_id = apstra_template_rack_based.cfd_18.id
}

resource "apstra_blueprint_deployment" "cfd_18" {
  blueprint_id = apstra_datacenter_blueprint.cfd_18.id
  depends_on = [
    apstra_datacenter_device_allocation.each,
    apstra_datacenter_resource_pool_allocation.blue_loopbacks,
    apstra_datacenter_resource_pool_allocation.blue_subnets,
    apstra_datacenter_resource_pool_allocation.fabric_asn,
    apstra_datacenter_resource_pool_allocation.fabric_evpn_l3_vni,
    apstra_datacenter_resource_pool_allocation.fabric_ip4,
    apstra_datacenter_resource_pool_allocation.fabric_vni,
    apstra_datacenter_generic_system.s1,
    apstra_datacenter_generic_system.s2,
    apstra_datacenter_generic_system.s3,
    apstra_datacenter_generic_system.s4,
    apstra_datacenter_connectivity_template_assignment.lb,
  ]
  comment      = "Deployment by Terraform {{.TerraformVersion}}, Apstra provider {{.ProviderVersion}}, User $USER."
}