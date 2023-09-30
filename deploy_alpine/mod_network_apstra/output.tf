output "subnet" { value = apstra_datacenter_virtual_network.o.ipv4_subnet }

output "vlan_id" { value = one(toset([for leaf, info in apstra_datacenter_virtual_network.o.bindings : info.vlan_id])) }
