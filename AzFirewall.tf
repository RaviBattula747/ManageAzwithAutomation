resource "azurerm_public_ip" "fw-ip" {
  count = 2
  name                = count.index < 1 ? "tf-fw-pip-ntw-q1-poc-shared-ea-01" : "tf-fw-pip-ntw-q1-poc-shared-sa-01"
  location            = local.location[count.index]
  resource_group_name = local.resource_group_name[count.index]
  allocation_method   = "Static"
  sku                 = "Standard"
  ddos_protection_mode= "Disabled"
      depends_on = [
    azurerm_resource_group.az-rg
	]
  lifecycle {
	ignore_changes = [tags["Test"]]
	}
}


resource "azurerm_firewall" "az-fw" {
  count = 2
  name                = count.index < 1 ? "tf-fw-ntw-q1-poc-shared-ea-01" : "tf-fw-ntw-q1-poc-shared-sa-01" 
  location            = local.location[count.index]
  resource_group_name = local.resource_group_name[count.index]
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = "${local.rg_id[count.index]}providers/Microsoft.Network/virtualNetworks/${local.virtualNetworks[count.index < 1 ? 0 : 4 ]}/subnets/AzureFirewallSubnet"
    public_ip_address_id = azurerm_public_ip.fw-ip[count.index].id
  }
    lifecycle {
	ignore_changes = [tags["Test"]]
	}
    depends_on = [
    azurerm_subnet.az-subnet,
    azurerm_public_ip.fw-ip
	]
}

resource "azurerm_firewall_nat_rule_collection" "fw-nat" {
  name                = "Dnat-collection"
  azure_firewall_name = azurerm_firewall.az-fw[0].name
  resource_group_name = azurerm_firewall.az-fw[0].resource_group_name
  priority            = 100
  action              = "Dnat"

  rule {
    name = "Dnatrule"
    source_addresses = ["*"]
    destination_ports = ["80"]
    destination_addresses = [azurerm_public_ip.fw-ip[0].ip_address]
    translated_port = 80
    translated_address = "10.6.2.4"
    protocols = ["TCP"]
  }
}

resource "azurerm_firewall_network_rule_collection" "fw1-rule" {

    for_each = {
      "SpokeToSpoke"        = [["10.6.1.5","10.6.1.6","10.6.2.4","10.7.1.4"],["80","443"],["10.6.1.5","10.6.1.6","10.6.2.4","10.7.1.4","10.6.0.132"],["TCP"],"100"]
      "Spoke2ToLBinSpoke1"  = [["10.6.2.4","10.7.1.4"],["3389"],["10.6.1.4","10.6.1.5","10.6.1.6"],["TCP"],"200"]
      "DnatRule"            = [["*"],["80"],["10.6.2.4"],["TCP"],"300"] 
    }
  name                = each.key
  azure_firewall_name = azurerm_firewall.az-fw[0].name
  resource_group_name = local.resource_group_name[0]
  priority            = each.value[4]
  action              = "Allow"


  rule {
    name                      = each.key
    source_addresses          = each.value[0]
    destination_ports         = each.value[1]
    destination_addresses     = each.value[2]
    protocols                 = each.value[3]
  }
      depends_on = [
    azurerm_firewall.az-fw
	]
}

resource "azurerm_firewall_network_rule_collection" "fw2-rule" {
    for_each = {
      
      "Spoke12ToSpokeDR"  = [["10.6.1.5","10.6.1.6","10.6.2.4","10.7.1.4"],["80","443"],["10.6.1.5","10.6.1.6","10.6.2.4","10.7.1.4","10.6.0.132"],["TCP"],"100"]
      "DrSpokeToLBinPrSpoke1"= [["10.7.1.4"],["3389"],["10.6.1.4","10.6.1.5","10.6.1.6"],["TCP"],"200"]
    }
  name                = each.key
  azure_firewall_name = azurerm_firewall.az-fw[1].name
  resource_group_name = local.resource_group_name[1]
  priority            = each.value[4]
  action              = "Allow"

  rule {
    name                      = each.key
    source_addresses          = each.value[0]
    destination_ports         = each.value[1]
    destination_addresses     = each.value[2]
    protocols                 = each.value[3]
  }
  depends_on = [
    azurerm_firewall.az-fw
	]
}

resource "azurerm_firewall_application_rule_collection" "fw-app" {
  name                = "app-collection"
  azure_firewall_name = azurerm_firewall.az-fw[0].name
  resource_group_name = azurerm_firewall.az-fw[0].resource_group_name
  priority            = 100
  action              = "Allow"

  rule {
    name = "AllowInternet4spk1"
    source_addresses = ["10.6.1.5",]
    target_fqdns = ["*",]
    protocol {
      port = "443"
      type = "Https"
    }
  }
}