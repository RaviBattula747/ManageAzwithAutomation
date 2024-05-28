resource "azurerm_subnet" "az-subnet" {
	for_each = {
		"10.6.0.0/26"	= [local.virtualNetworks[0],local.subnets[0],local.resource_group_name[0]]
		"10.6.0.64/26"	= [local.virtualNetworks[0],local.subnets[1],local.resource_group_name[0]]
		"10.7.0.0/26"	= [local.virtualNetworks[4],local.subnets[0],local.resource_group_name[1]]
		"10.7.0.64/26"	= [local.virtualNetworks[4],local.subnets[1],local.resource_group_name[1]]
		"10.6.0.128/25"	= [local.virtualNetworks[0],local.subnets[2],local.resource_group_name[0]]
		"10.7.0.128/25"	= [local.virtualNetworks[4],local.subnets[6],local.resource_group_name[1]]
		"10.6.1.0/24"	= [local.virtualNetworks[1],local.subnets[3],local.resource_group_name[0]]
		"10.6.2.0/24"	= [local.virtualNetworks[2],local.subnets[4],local.resource_group_name[0]]
		"10.7.1.0/24"	= [local.virtualNetworks[3],local.subnets[5],local.resource_group_name[1]]


	}
	name					= each.value[1]
	resource_group_name		= each.value[2]
	virtual_network_name	= each.value[0]
	address_prefixes		= [each.key]
	depends_on = [
		azurerm_resource_group.az-rg,
		azurerm_virtual_network.az-vnet,
	]
}