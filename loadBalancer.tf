
resource "azurerm_lb" "az_lb" {
  name = "tf-int-lb-ntw-q1-poc-01"
  location = azurerm_resource_group.az-rg[0].location
  resource_group_name = azurerm_resource_group.az-rg[0].name
  sku = "Standard"

  frontend_ip_configuration {
    name = "frontend-ip"
    subnet_id = azurerm_subnet.az-subnet["10.6.1.0/24"].id
    private_ip_address_allocation = "Static"
    private_ip_address  = "10.6.1.4"
  }
  	lifecycle {
	ignore_changes = [tags["Test"]]
	}
  	depends_on = [
		azurerm_resource_group.az-rg
	]
}

resource "azurerm_lb_backend_address_pool" "az_lb_pool" {
  loadbalancer_id = azurerm_lb.az_lb.id
  name = "lb-pool"
  	depends_on = [azurerm_lb.az_lb]
}

resource "azurerm_lb_backend_address_pool_address" "bk-addr" {
  count = 2
  name                    = "backend-${count.index}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.az_lb_pool.id
  virtual_network_id      = azurerm_virtual_network.az-vnet["10.6.1.0/24"].id
  ip_address              = "10.6.1.${count.index+5}"
  	depends_on = [
		azurerm_resource_group.az-rg,
    azurerm_lb.az_lb
	]
}

resource "azurerm_lb_probe" "az_lb_probe" {
  #resource_group_name = azurerm_resource_group.az-rg[0].name
  loadbalancer_id = azurerm_lb.az_lb.id
  name = "lb-health-probe"
  port = 3389
}

resource "azurerm_lb_rule" "my_lb_rule" {
  #resource_group_name = azurerm_resource_group.az-rg[0].name
  loadbalancer_id = azurerm_lb.az_lb.id
  name = "lb-rule"
  protocol = "Tcp"
  frontend_port = 3389
  backend_port = 3389
  disable_outbound_snat = true
  frontend_ip_configuration_name = "frontend-ip"
  probe_id = azurerm_lb_probe.az_lb_probe.id
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.az_lb_pool.id]
}

