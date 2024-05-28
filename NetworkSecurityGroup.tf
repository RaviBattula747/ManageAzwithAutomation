
resource "azurerm_network_security_group" "az-nsg"{
	count=3
	name			= local.nsg_name[count.index]
	location		= local.location[count.index< 2 ? 0 :1]
	resource_group_name	= local.resource_group_name[count.index<2 ? 0 :1]
	lifecycle {
	ignore_changes = [tags["Test"]]
	}
	depends_on = [
		azurerm_resource_group.az-rg
	]
}

resource "azurerm_network_security_rule" "az-nsg-rule"{
for_each = {
	rule1				= ["AllowBastionConnectivity",100,"Inbound","Allow","Tcp","*",["3389"],["10.6.0.0/26","10.6.2.4","10.7.1.4","168.63.129.16"],["10.6.1.4","10.6.1.5","10.6.1.6"],0,0]
	rule2				= ["AllowHttpfromSpoke2",110,"Inbound","Allow","Tcp","*",["80"],["10.6.2.0/24","10.6.1.5","10.6.1.6"],["10.6.1.5","10.6.1.6"],0,0]
    rule3				= ["AllowHttpfromDrSpoke",120,"Inbound","Allow","Tcp","*",["80"],["10.7.1.0/24"],["10.6.1.5","10.6.1.6"],0,0]
	rule4				= ["AllowBastionConnectivity",100,"Inbound","Allow","Tcp","*",["3389"],["10.6.0.0/26"],["10.6.2.4"],0,1]
	rule5				= ["AllowHttpfromSpoke1",110,"Inbound","Allow","Tcp","*",["80"],["10.6.1.0/24","167.103.6.247","223.187.40.166","10.6.0.64/26"],["10.6.2.4"],0,1]
	rule6				= ["AllowHttpfromDrSpoke",120,"Inbound","Allow","Tcp","*",["80"],["10.7.1.0/24"],["10.6.2.4"],0,1]
	rule7				= ["AllowBastionConnectivity",100,"Inbound","Allow","Tcp","*",["3389"],["10.7.0.0/26"],["10.7.1.4"],1,2]
	rule8				= ["AllowHttpfromSpkoket0Dr",110,"Inbound","Allow","Tcp","*",["80"],["10.6.1.0/24","10.6.2.0/24"],["10.7.1.4"],1,2]
}
		name							= each.value[0]
		priority						= each.value[1]
		direction						= each.value[2]
		access							= each.value[3]
		protocol						= each.value[4]
		source_port_range				= each.value[5]
		destination_port_ranges			= each.value[6]
		source_address_prefixes			= each.value[7]
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

