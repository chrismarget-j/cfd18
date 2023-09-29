data "apstra_agents" "all" {}

data "apstra_agent" "each" {
  for_each = data.apstra_agents.all.ids
  agent_id = each.key
}

resource "apstra_managed_device_ack" "each" {
  for_each = data.apstra_agent.each
  agent_id = each.value.agent_id
  device_key = each.value.device_key
}
