declare -A r
input1="/home/ravi_battula/datadisks.txt"
input2="/home/ravi_battula/osdisks.txt"
r[0]="/subscriptions/f63fa6ca-967f-4ff6-8e38-554feccee894/resourceGroups/rg-dr-app-db-non-pci-np-qa-01/providers/Microsoft.Compute/virtualMachines/cllrqnexter01"
r[1]="/subscriptions/74fc6867-eae0-4eb9-9a87-b89164d250dd/resourceGroups/rg-dr-app-non-pci-windows-prd-01/providers/Microsoft.Compute/virtualMachines/CLWRPSQLANL03"
r[2]="/subscriptions/b3f964c7-1d16-4c8d-8240-dd1b6a30a429/resourceGroups/rg-dr-infra-vm-prd-linux-ss-01/providers/Microsoft.Compute/virtualMachines/cllrpsysdashdb01"
r[3]="/subscriptions/b3f964c7-1d16-4c8d-8240-dd1b6a30a429/resourceGroups/rg-dr-infra-vm-prd-windows-ss-01/providers/Microsoft.Compute/virtualMachines/CLWRPIVLANDESK01"
r[4]="/subscriptions/74fc6867-eae0-4eb9-9a87-b89164d250dd/resourceGroups/rg-dr-app-non-pci-windows-prd-01/providers/Microsoft.Compute/virtualMachines/CLWRPDYNSQLRPT01"
r[5]="/subscriptions/74fc6867-eae0-4eb9-9a87-b89164d250dd/resourceGroups/rg-dr-app-non-pci-windows-prd-01/providers/Microsoft.Compute/virtualMachines/clwrpfinsql01"
r[6]="/subscriptions/74fc6867-eae0-4eb9-9a87-b89164d250dd/resourceGroups/rg-dr-app-non-pci-windows-prd-01/providers/Microsoft.Compute/virtualMachines/CLWRPSQLANL01"
for (( i=0 ; i<7 ; i++ )){
az vm show --ids ${r[$i]} --query storageProfile.dataDisks[*].managedDisk.id -o tsv > datadisks.txt
az vm show --ids ${r[$i]} --query storageProfile.osDisk.managedDisk.id -o tsv > osdisks.txt

while read -r liner
        do
        ddId=$liner
        az disk show --ids $ddId --query [name,diskSizeGb,diskIopsReadWrite,diskMBpsReadWrite] -o table >> resultforDiskSizes.txt
        done < "$input1"
while read -r liner
        do
        odId=$liner
        az disk show --ids $odId --query [name,diskSizeGb,diskIopsReadWrite,diskMBpsReadWrite] -o table >> resultforDiskSizes.txt
        done < "$input2"

}