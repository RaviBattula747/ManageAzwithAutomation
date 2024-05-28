resource "azurerm_storage_account" "az-sa" {

name			= "santwq1poc1234512345"
resource_group_name	= local.resource_group_name[0]
location		= local.location[0]
account_tier		= "Standard"
account_replication_type= "LRS"
#public_network_access_enabled = false

depends_on = [
azurerm_resource_group.az-rg
]

lifecycle {
ignore_changes = [tags["Test"]]
}

}


resource "azurerm_private_endpoint" "az-pe" {
name		= "pe-sa-ntw-q1-poc-01"
location	= local.location[0]
resource_group_name	= local.resource_group_name[0]
subnet_id	= azurerm_subnet.az-subnet["10.6.0.128/25"].id
#"${local.rd_id[0]}/providers/microsoftnetworks/virtualnetworks/${local.vnet[1]}/subnets/${local.subnets[0]}"

private_service_connection {
name		= "pe-cnc-sa-ntw-q1-poc-01"
private_connection_resource_id	= azurerm_storage_account.az-sa.id
subresource_names		= ["blob"]
is_manual_connection  = false
}

private_dns_zone_group {
name		= "pe-dns-zone-group"
private_dns_zone_ids 	= [azurerm_private_dns_zone.dnszone.id]
}
depends_on = [azurerm_private_dns_zone.dnszone]

lifecycle {
ignore_changes = [tags["Test"]]
}
}

resource "azurerm_private_dns_zone" "dnszone" {
name		= "privatelink.blob.core.windows.net"
resource_group_name = azurerm_storage_account.az-sa.resource_group_name
depends_on = [azurerm_storage_account.az-sa]
lifecycle {
ignore_changes = [tags["Test"]]
}
}

resource "azurerm_private_dns_zone_virtual_network_link" "pe-dns-link" {
  count = 3
  name                  = count.index < 1 ? "link1" : count.index < 2 ? "link2" : "link3"
  resource_group_name   = azurerm_private_dns_zone.dnszone.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.dnszone.name
  virtual_network_id   = azurerm_virtual_network.az-vnet[count.index < 1 ? "10.6.0.0/24" :  count.index < 2 ? "10.6.1.0/24" : "10.7.1.0/24"].id
  depends_on = [azurerm_private_dns_zone.dnszone]
  	lifecycle {
	ignore_changes = [tags["Test"]]
	}
}

resource "azurerm_storage_container" "blob-container" {
  name                  = "container"
  storage_account_name  = azurerm_storage_account.az-sa.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "example" {
  name                   = "picOfaGirl"
  storage_account_name   = azurerm_storage_account.az-sa.name
  storage_container_name = azurerm_storage_container.blob-container.name
  type                   = "Block"
  source                 = "btpic.png"
}