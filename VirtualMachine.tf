locals {
    vm  =   ["tf-vm-ntw-q1-poc-spk1-ea-01","tf-vm-ntw-q1-poc-spk1-ea-02","tf-vm-ntw-q1-poc-spk2-ea-01","tf-vm-ntw-q1-poc-spk1-sa-01"]
}


resource "azurerm_network_interface" "az-nic" {
for_each = {
# s.no = [nic IP, subnet space, nic name]
    0  =   ["10.6.1.5","10.6.1.0/24","nic-ntw-q1-poc-spk1-ea-01"]
    1  =   ["10.6.1.6","10.6.1.0/24","nic-ntw-q1-poc-spk1-ea-02"]
    2  =   ["10.6.2.4","10.6.2.0/24","nic-ntw-q1-poc-spk2-ea-01"]
    3  =   ["10.7.1.4","10.7.1.0/24","nic-ntw-q1-poc-spk1-sa-01"]
}
  name                = each.value[2]
  location            = local.location[strcontains(each.value[2] , "-ea-") ? 0 : 1]
  resource_group_name = azurerm_subnet.az-subnet[each.value[1]].resource_group_name

  ip_configuration {
    name                          = "IPconfiguration1"
    subnet_id                     = "/subscriptions/23efc783-848f-402e-a416-c9e2da010dc7/resourceGroups/${azurerm_subnet.az-subnet[each.value[1]].resource_group_name}/providers/Microsoft.Network/virtualNetworks/${azurerm_subnet.az-subnet[each.value[1]].virtual_network_name}/subnets/${azurerm_subnet.az-subnet[each.value[1]].name}"
    private_ip_address_allocation = "Static"
    private_ip_address            = each.value[0]
  }
	lifecycle {
	ignore_changes = [tags["Test"]]
	}
  depends_on =  [azurerm_subnet.az-subnet,]
}

resource "azurerm_virtual_machine" "az-vm" {
  count =  4
  name                  = local.vm[count.index]
  location              = azurerm_network_interface.az-nic[count.index].location
  resource_group_name   = azurerm_network_interface.az-nic[count.index].resource_group_name
  network_interface_ids = [azurerm_network_interface.az-nic[count.index].id]
  vm_size               = "Standard_B2ms"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true
  storage_image_reference {

    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-datacenter-gensecond"
    version   = "latest"
    #"exactVersion": "19045.3930.240104"
  }
  storage_os_disk {
    name              = "${local.vm[count.index]}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${substr(local.vm[count.index], -10, -1)}"
    admin_username = "tcsntw"
    admin_password = "Tcsntw@12341234"
  }
  os_profile_windows_config {
    provision_vm_agent  = true
  }
  	lifecycle {
	ignore_changes = [tags["Test"]]
	}
  depends_on =  [azurerm_network_interface.az-nic]
}
/*
userdata = <<-EOF
<powershell>
 Install-WindowsFeature -name Web-Server -IncludeManagementTools
 Remove-Item C:\inetpub\wwwroot\iisstart.htm
 Add-Content -Path "C:\inetpub\wwwroot\iisstart.htm" -Value $("Hello World from " + $env:computername)
</powershell>
EOF
  	depends_on = [azurerm_network_interface.az-nic] 
*/
/*
resource "azurerm_virtual_machine_extension" "IISInstallation" {
  count = 4
  name                 = "install_iis"
  virtual_machine_id   = azurerm_virtual_machine.az-vm[count.index].id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.8"
  auto_upgrade_minor_version = true
#   "commandToExecute":"powershell Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools; powershell Add-Content -Path \"C:\\inetpub\\wwwroot\\Default.htm\" -Value $($env:computername)"}

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell -ExecutionPolicy Unrestricted Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools ; powershell Add-Content -Path \"C:\\inetpub\\wwwroot\\Default.htm\" -Value $($env:computername)"
    }
SETTINGS

depends_on = [azurerm_virtual_machine.az-vm] 
}
*/