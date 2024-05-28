# Associating Networkk security groups
resource "azurerm_subnet_network_security_group_association" "link-Subnet-NSG" {
	count	=	3
  	subnet_id                 = "${local.rg_id[count.index < 2 ? 0 : 1]}providers/Microsoft.Network/virtualNetworks/${local.virtualNetworks[count.index < 1 ? 1 : count.index < 2 ? 2 : 3]}/subnets/${local.subnets[count.index+3]}"
  	#subnet_id                 = format("%s%s%s%s","${local.rg_id[0]}","providers/Microsoft.Network/virtualNetworks/","${local.virtualNetworks[1]}/","subnets/${local.subnets[3]}")
  	network_security_group_id = "${local.rg_id[count.index < 2 ? 0 : 1]}providers/Microsoft.Network/networkSecurityGroups/${local.nsg_name[count.index]}"

  	depends_on = [
		azurerm_subnet.az-subnet,
		azurerm_network_security_group.az-nsg
	]
}