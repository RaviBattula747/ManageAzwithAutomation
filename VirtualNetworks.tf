locals	{
	virtualNetworks	=	["vnet-ntw-q1-poc-shared-ci-11","vnet-ntw-q1-poc-spoke-ci-11","vnet-ntw-q1-poc-spoke-ci-12","vnet-ntw-q1-poc-spoke-si-11","vnet-ntw-q1-poc-shared-si-11"]
}

resource "azurerm_virtual_network" "az-vnet" {

	for_each = {
		"10.6.0.0/24"	=	[local.virtualNetworks[0],local.resource_group_name[0],local.location[0]]
		"10.6.1.0/24"	=	[local.virtualNetworks[1],local.resource_group_name[0],local.location[0]]
		"10.6.2.0/24"	=	[local.virtualNetworks[2],local.resource_group_name[0],local.location[0]]
		"10.7.1.0/24"	=	[local.virtualNetworks[3],local.resource_group_name[1],local.location[1]]
		"10.7.0.0/24"	=	[local.virtualNetworks[4],local.resource_group_name[1],local.location[1]]
	}

	name				= each.value[0]
	address_space		= [each.key]
	resource_group_name	= each.value[1]
	location			= each.value[2]
	lifecycle {
	ignore_changes = [tags["Test"]]
	}
	depends_on = [
		azurerm_resource_group.az-rg
	]
} 


resource "azurerm_virtual_network_peering" "peering" {

	for_each = {
		# PeerName	=	[rg_id no., remote vnet index, vnet index, rg, loc, fw traffic]

		"peer-shared-spoke-11-ci"	=	[0,1,0,0,false]
		"peer-spoke-11-shared-ci"	=	[0,0,1,0,false]

		"peer-shared-spoke-12-ci"	=	[0,2,0,0,false]
		"peer-spoke-12-shared-ci"	=	[0,0,2,0,false]
		
		"Global-peer-shared-ci-si"	=	[1,4,0,0,true]
		"Global-peer-shared-si-ci"	=	[0,0,4,1,true]

		"peer-shared-spoke-01-si"	=	[1,3,4,1,false]
		"peer-spoke-shared-01-si"	=	[1,4,3,1,false]
	}

  name                      = each.key
  resource_group_name       = local.resource_group_name[each.value[3]]
  virtual_network_name      = local.virtualNetworks[each.value[2]]
  remote_virtual_network_id = "${local.rg_id[each.value[0]]}providers/Microsoft.Network/virtualNetworks/${local.virtualNetworks[each.value[1]]}"
  allow_forwarded_traffic	= each.value[4]
  	depends_on = [
		azurerm_resource_group.az-rg,
		azurerm_virtual_network.az-vnet
	]
}

