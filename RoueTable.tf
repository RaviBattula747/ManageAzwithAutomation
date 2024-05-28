
resource "azurerm_route_table" "az-rt" {
  count = 5
  name                          = local.route_tables[count.index]
  location                      = local.location[count.index < 3 ? 0 : 1]
  resource_group_name           = local.resource_group_name[count.index < 3 ? 0 : 1]
  disable_bgp_route_propagation = false

lifecycle {
ignore_changes = [tags["Test"]]
}

	depends_on = [
		azurerm_resource_group.az-rg
	]
}

resource "azurerm_route" "az-rt-rule" {
for_each = {
	route1 = [local.route_tables[0],"10.7.1.0/24","VirtualAppliance","10.7.0.68","toRegion2",local.resource_group_name[0]]
  route2 = [local.route_tables[1],"0.0.0.0/0","VirtualAppliance","10.6.0.68","Default",local.resource_group_name[0]]
  route3 = [local.route_tables[2],"0.0.0.0/0","VirtualAppliance","10.6.0.68","Default",local.resource_group_name[0]]
  route4 = [local.route_tables[4],"10.6.1.0/24","VirtualAppliance","10.6.0.68","toRegion1spk1",local.resource_group_name[1]]
  route5 = [local.route_tables[4],"10.6.2.0/24","VirtualAppliance","10.6.0.68","toRegion1spk2",local.resource_group_name[1]]
  route6 = [local.route_tables[3],"0.0.0.0/0","VirtualAppliance","10.7.0.68","Default",local.resource_group_name[1]]
}
  name                = each.value[4]
  resource_group_name = each.value[5]
  route_table_name    = each.value[0]
  address_prefix      = each.value[1]
  next_hop_type       = each.value[2]
  next_hop_in_ip_address = each.value[3]
    depends_on = [
		azurerm_resource_group.az-rg,
    azurerm_route_table.az-rt
	]
}

resource "azurerm_route" "az-rt-fw" {
for_each = {
  route7 = [local.route_tables[0],"0.0.0.0/0","Internet","Default",local.resource_group_name[0]]
  route8 = [local.route_tables[4],"0.0.0.0/0","Internet","Default",local.resource_group_name[1]]
}
  name                = each.value[3]
  resource_group_name = each.value[4]
  route_table_name    = each.value[0]
  address_prefix      = each.value[1]
  next_hop_type       = each.value[2]
  #next_hop_in_ip_address = each.value[3]
    depends_on = [
		azurerm_resource_group.az-rg,
    azurerm_route_table.az-rt
	]
}

resource "azurerm_subnet_route_table_association" "az-sn-rt" {
  for_each = {
     1 = [azurerm_subnet.az-subnet["10.6.0.64/26"].id, azurerm_route_table.az-rt[0].id]
     2 = [azurerm_subnet.az-subnet["10.6.1.0/24"].id, azurerm_route_table.az-rt[1].id]
     3 = [azurerm_subnet.az-subnet["10.6.2.0/24"].id, azurerm_route_table.az-rt[2].id]
     4 = [azurerm_subnet.az-subnet["10.7.1.0/24"].id, azurerm_route_table.az-rt[3].id]
     5 = [azurerm_subnet.az-subnet["10.7.0.64/26"].id, azurerm_route_table.az-rt[4].id]
  }
  subnet_id      =  each.value[0]
  #"${local.rg_id[count.index < 2 ? 0 : 1]}providers/Microsoft.Network/virtualNetworks/${local.virtualNetworks[count.index+1]}/subnets/${local.subnets[count.index+3]}"
  route_table_id = each.value[1]
  #"${local.rg_id[count.index < 2 ? 0 : 1]}providers/Microsoft.Network/routeTables/${local.route_tables[count.index+1]}"
  depends_on = [
		azurerm_resource_group.az-rg,
    azurerm_route_table.az-rt,
    azurerm_subnet.az-subnet
	]

}