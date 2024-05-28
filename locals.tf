locals {
        resource_group_name     = ["tf-rg-ntw-q1-poc-ea-01","tf-rg-ntw-q1-poc-sa-01"]
        location                = ["East Asia", "Southeast Asia"]
        virtualNetworks	        = ["tf-vnet-ntw-q1-poc-shared-ea-01","tf-vnet-ntw-q1-poc-spoke-ea-01","tf-vnet-ntw-q1-poc-spoke-ea-02","tf-vnet-ntw-q1-poc-spoke-sa-01","tf-vnet-ntw-q1-poc-shared-sa-01"]
        subnets         	= ["AzureBastionSubnet","AzureFirewallSubnet","snet-ntw-q1-poc-shared-ea-01","snet-ntw-q1-poc-spoke-ea-01","snet-ntw-q1-poc-spoke-ea-02","snet-ntw-q1-poc-spoke-sa-01",	"snet-ntw-q1-poc-shared-sa-01"]  
        nsg_name		= ["tf-nsg-ntw-q1-poc-spoke-ea-01","tf-nsg-ntw-q1-poc-spoke-ea-02","tf-nsg-ntw-q1-poc-spoke-sa-01"]
	route_tables            = ["tf-rt-ntw-q1-poc-shared-ea-01","tf-rt-ntw-q1-poc-spoke-ea-01","tf-rt-ntw-q1-poc-spoke-ea-02","tf-rt-ntw-q1-poc-spoke-sa-01","tf-rt-ntw-q1-poc-shared-sa-01"]        
        rg_id                   = ["/subscriptions/23efc783-848f-402e-a416-c9e2da010dc7/resourceGroups/tf-rg-ntw-q1-poc-ea-01/","/subscriptions/23efc783-848f-402e-a416-c9e2da010dc7/resourceGroups/tf-rg-ntw-q1-poc-sa-01/"]
}