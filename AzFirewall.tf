locals {
    id  =   "/subscriptions/23efc783-848f-402e-a416-c9e2da010dc7/resourceGroups/rg-ntw-q1-poc-ci-11/providers/Microsoft.Network/virtualNetworks/vnet-ntw-q1-poc-shared-ci-11"
    id2 =   "/subscriptions/23efc783-848f-402e-a416-c9e2da010dc7/resourceGroups/rg-ntw-q1-poc-si-11/providers/Microsoft.Network/virtualNetworks/vnet-ntw-q1-poc-shared-si-11"
}

   /* id  =   ["/subscriptions/23efc783-848f-402e-a416-c9e2da010dc7/resourceGroups/rg-ntw-q1-poc-ci-11/providers/Microsoft.Network/virtualNetworks/vnet-ntw-q1-poc-shared-ci-11","/subscriptions/23efc783-848f-402e-a416-c9e2da010dc7/resourceGroups/rg-ntw-q1-poc-si-11/providers/Microsoft.Network/virtualNetworks/vnet-ntw-q1-poc-shared-si-11"]
    pips  = ["fwpip--ntw-q1-poc-shared-ci-11","fwpip-ntw-q1-poc-shared-si-11"]
    firewall  = ["fw-ntw-q1-poc-shared-ci-11","fw-ntw-q1-poc-shared-si-11"] */

resource "azurerm_public_ip" "fw-ip" {
  name                = "fwpip--ntw-q1-poc-shared-ci-11"
  location            = local.location[0]
  resource_group_name = local.resource_group_name[0]
  allocation_method   = "Static"
  sku                 = "Standard"
  lifecycle {
	ignore_changes = [tags["Test"]]
	}
}

resource "azurerm_public_ip" "fw-ip2" {
  name                = "fwpip--ntw-q1-poc-shared-si-11"
  location            = local.location[1]
  resource_group_name = local.resource_group_name[1]
  allocation_method   = "Static"
  sku                 = "Standard"
  lifecycle {
	ignore_changes = [tags["Test"]]
	}
}

resource "azurerm_firewall" "az-fw" {
  name                = "fw-ntw-q1-poc-shared-ci-11"
  location            = local.location[0]
  resource_group_name = local.resource_group_name[0]
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = "${local.id}/subnets/AzureFirewallSubnet"
    public_ip_address_id = azurerm_public_ip.fw-ip.id
  }
    lifecycle {
	ignore_changes = [tags["Test"]]
	}
    depends_on = [
    azurerm_subnet.az-subnet,
    azurerm_public_ip.fw-ip
	]
}

resource "azurerm_firewall" "az-fw2" {
  name                = "fw-ntw-q1-poc-shared-si-11"
  location            = local.location[1]
  resource_group_name = local.resource_group_name[1]
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = "${local.id2}/subnets/AzureFirewallSubnet"
    public_ip_address_id = azurerm_public_ip.fw-ip2.id
  }
    lifecycle {
	ignore_changes = [tags["Test"]]
	}
    depends_on = [
    azurerm_subnet.az-subnet,
    azurerm_public_ip.fw-ip2
	]
}