locals {
	route_tables = ["rt-ntw-q1-poc-shared-ci-11","rt-ntw-q1-poc-spoke-ci-11","rt-ntw-q1-poc-spoke-ci-12","rt-ntw-q1-poc-spoke-si-11","rt-ntw-q1-poc-shared-si-11"]
}

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

resource "azurerm_subnet_route_table_association" "az-sn-rt" {
  count =  5
  subnet_id      = "${local.rg_id[count.index < 3 ? 0 : 1]}providers/Microsoft.Network/virtualNetworks/${local.virtualNetworks[count.index]}/subnets/${local.subnets[count.index+2]}"
  route_table_id = "${local.rg_id[count.index < 3 ? 0 : 1]}providers/Microsoft.Network/routeTables/${local.route_tables[count.index]}"
  depends_on = [
		azurerm_resource_group.az-rg,
    azurerm_route_table.az-rt,
    azurerm_subnet.az-subnet
	]

}