
locals {
	nsgrg			= [local.resource_group_name[0],local.resource_group_name[0],local.resource_group_name[1]]
	nsgloc			= [local.location[0],local.location[0],local.location[1]]
	nsg_name		= ["nsg-ntw-q1-poc-spoke-ci-11","nsg-ntw-q1-poc-spoke-ci-12","nsg-ntw-q1-poc-spoke-si-11"]
}

resource "azurerm_network_security_group" "az-nsg"{
	count=3
	name			= local.nsg_name[count.index]
	location		= local.nsgloc[count.index]
	resource_group_name	= local.nsgrg[count.index]
	lifecycle {
	ignore_changes = [tags["Test"]]
	}
	depends_on = [
		azurerm_resource_group.az-rg
	]
}

resource "azurerm_network_security_rule" "az-nsg-rule"{
for_each = {
	rule1				= ["AllowBastionConnectivity",100,"Inbound","Allow","Tcp","*",["3389"],["10.6.0.0/26"],["10.6.1.5","10.6.1.6"],0,0]
	rule2				= ["AllowHttpsfromSpoke2",110,"Inbound","Allow","Tcp","*",["443"],["10.6.2.0/24"],["10.6.1.5","10.6.1.6"],0,0]
        rule3				= ["AllowHttpsfromDrSpoke",120,"Inbound","Allow","Tcp","*",["443"],["10.7.1.0/24"],["10.6.1.5","10.6.1.6"],0,0]
	rule4				= ["AllowBastionConnectivity",100,"Inbound","Allow","Tcp","*",["3389"],["10.6.0.0/26"],["10.6.2.4"],0,1]
	rule5				= ["AllowHttpsfromSpoke1",110,"Inbound","Allow","Tcp","*",["443"],["10.6.2.0/24"],["10.6.2.4"],0,1]
	rule6				= ["AllowHttpsfromDrSpoke",120,"Inbound","Allow","Tcp","*",["443"],["10.7.1.0/24"],["10.6.2.4"],0,1]
	rule7				= ["AllowBastionConnectivity",100,"Inbound","Allow","Tcp","*",["3389"],["10.7.0.0/26"],["10.7.2.4"],1,2]
	rule8				= ["AllowHttpsfromSDrpoke",110,"Inbound","Allow","Tcp","*",["443"],["10.6.1.0/24","10.6.2.0/24"],["10.7.2.4"],1,2]
}
		name				= each.value[0]
		priority			= each.value[1]
		direction			= each.value[2]
		access				= each.value[3]
		protocol			= each.value[4]
		source_port_range		= each.value[5]
		destination_port_ranges		= each.value[6]
		source_address_prefixes		= each.value[7]
		destination_address_prefixes	= each.value[8]
		resource_group_name         	= local.resource_group_name[each.value[9]]
  		network_security_group_name 	= local.nsg_name[each.value[10]]

	depends_on = [
		azurerm_network_security_group.az-nsg
	]
}

resource "azurerm_network_security_rule" "az-nsg-deny-rules"{
for_each = {
	rule1				= ["Deny_All",4096,"Inbound","Deny","*","*","*","*","*",0,0]
	rule2				= ["Deny_All",4096,"Inbound","Deny","*","*","*","*","*",0,1]
	rule3				= ["Deny_All",4096,"Inbound","Deny","*","*","*","*","*",1,2]
}
		name				= each.value[0]
		priority			= each.value[1]
		direction			= each.value[2]
		access				= each.value[3]
		protocol			= each.value[4]
		source_port_range 		= each.value[5]
		destination_port_range		= each.value[6]
		source_address_prefix		= each.value[7]
		destination_address_prefix 	= each.value[8]
		resource_group_name         	= local.resource_group_name[each.value[9]]
  		network_security_group_name 	= local.nsg_name[each.value[10]]
	depends_on = [
		azurerm_network_security_group.az-nsg
	]
}

# Associating NEtworkk security groups
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

