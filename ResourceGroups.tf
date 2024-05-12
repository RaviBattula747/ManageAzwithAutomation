locals {
        resource_group_name     = ["rg-ntw-q1-poc-ci-11","rg-ntw-q1-poc-si-11"]
        location                = ["Central India", "South India"]
        rg_id  = ["/subscriptions/23efc783-848f-402e-a416-c9e2da010dc7/resourceGroups/rg-ntw-q1-poc-ci-11/","/subscriptions/23efc783-848f-402e-a416-c9e2da010dc7/resourceGroups/rg-ntw-q1-poc-si-11/"]
}
resource "azurerm_resource_group" "az-rg" {
    count=2
    name = local.resource_group_name[count.index]
    location = local.location[count.index]
    lifecycle {
    ignore_changes = [tags["Test"]]
    }
}