declare -A r
r[0]=/subscriptions/74fc6867-eae0-4eb9-9a87-b89164d250dd/resourceGroups/rg-app-non-pci-windows-prd-01/providers/Microsoft.Compute/virtualMachines/CLWPNEWSWAYRIP1
r[1]=/subscriptions/74fc6867-eae0-4eb9-9a87-b89164d250dd/resourceGroups/rg-app-non-pci-windows-prd-01/providers/Microsoft.Compute/virtualMachines/CLWPNEWSWAYRIP2
r[2]=/subscriptions/74fc6867-eae0-4eb9-9a87-b89164d250dd/resourceGroups/rg-app-non-pci-windows-prd-01/providers/Microsoft.Compute/virtualMachines/CLWPNEWSWAYRIP3
r[3]=/subscriptions/74fc6867-eae0-4eb9-9a87-b89164d250dd/resourceGroups/rg-app-non-pci-windows-prd-01/providers/Microsoft.Compute/virtualMachines/CLWPNEWSWAYX01
r[4]=/subscriptions/74fc6867-eae0-4eb9-9a87-b89164d250dd/resourceGroups/rg-app-non-pci-windows-prd-01/providers/Microsoft.Compute/virtualMachines/CLWPNEWSWAYX02

for (( i=0 ; i<5 ; i++ )){
    az vm deallocate --ids ${r[$i]}
}