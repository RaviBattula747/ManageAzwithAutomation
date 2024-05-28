resource "azurerm_public_ip" "bs-ip" {
  count = 2
  name                = count.index < 1 ? "tf-bs-pip-ntw-q1-poc-shared-ea-01" : "tf-bs-pip-ntw-q1-poc-shared-sa-01"
  location            = local.location[count.index]
  resource_group_name = local.resource_group_name[count.index]
  allocation_method   = "Static"
  sku                 = "Standard"
  ddos_protection_mode= "Disabled"
  lifecycle {
	ignore_changes = [tags["Test"]]
	}
  	depends_on = [
		azurerm_resource_group.az-rg
	]
}

resource "azurerm_bastion_host" "az-bastion" {
count = 2
  name                = count.index < 1 ? "bst-ntw-q1-poc-shared-ea-01" : "bst-ntw-q1-poc-shared-sa-01"
  location            = local.location[count.index]
  resource_group_name = local.resource_group_name[count.index]
  ip_configuration {
    name                 = "configuration"
    subnet_id            = "${local.rg_id[count.index]}providers/Microsoft.Network/virtualNetworks/${local.virtualNetworks[count.index < 1 ? 0 : 4 ]}/subnets/AzureBastionSubnet"
    public_ip_address_id = azurerm_public_ip.bs-ip[count.index].id
  }
      lifecycle {
	ignore_changes = [tags["Test"]]
	}
  	depends_on = [
		azurerm_public_ip.bs-ip
	]
}