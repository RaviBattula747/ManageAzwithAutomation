resource "azurerm_resource_group" "az-rg" {
    count=2
    name = local.resource_group_name[count.index]
    location = local.location[count.index]
    lifecycle {
    ignore_changes = [tags["Test"]]
    }
}