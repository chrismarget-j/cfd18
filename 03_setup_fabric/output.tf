output "blueprint_id" { value = apstra_datacenter_blueprint.cfd_18.id }

output "routing_zone_id" { value = apstra_datacenter_routing_zone.cfd_18.id }

output "lb_subnet" { value = local.lb_subnet }
