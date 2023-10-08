output "subnet" { value = apstra_datacenter_virtual_network.o.ipv4_subnet }

output "vlan_id" { value = one(toset([for leaf, info in apstra_datacenter_virtual_network.o.bindings : info.vlan_id])) }

output "ct_tagged" { value = apstra_datacenter_connectivity_template.tagged.id }

output "ct_untagged" { value = apstra_datacenter_connectivity_template.untagged.id }

output "ipv4_subnet" { value = apstra_datacenter_virtual_network.o.ipv4_subnet }

output "name" { value = apstra_datacenter_virtual_network.o.name }
