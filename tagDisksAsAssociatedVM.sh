#az vm show --name CLWPDYNSQLRPT01 --subscription NANTMEDIA-PRD—01 --resource-group rg-app-non-pci-windows-prd-01 --query storageProfile.dataDisks[*].name
#/subscriptions/b3f964c7-1d16-4c8d-8240-dd1b6a30a429/resourceGroups/rg-dr-infra-vm-prd-windows-ad-ss-01/providers/Microsoft.Compute/virtualMachines/azeussdc01

declare -A Laks
Laks[f63fa6ca-967f-4ff6-8e38-554feccee894]="NANTMEDIA-NP—01"
Laks[74fc6867-eae0-4eb9-9a87-b89164d250dd]="NANTMEDIA-PRD—01"
Laks[307229a7-f578-4e4c-b96e-522183580ae3]="NANTMEDIA-SANDBOX-01"
Laks[b3f964c7-1d16-4c8d-8240-dd1b6a30a429]="NANTMEDIA-SS—01"
Laks[1bffd3a8-c19d-4216-be31-6461c03d2180]="NANTMEDIA-VDI-01"

input="/home/ravi_battula/file143l.txt"
input1="/home/ravi_battula/datadisks.txt"
input2="/home/ravi_battula/osdisks.txt"
key="Application"

while read -r lines
do
        value=$(echo $lines | cut -d, -f1)
        rl=$(echo $lines | cut -d, -f2)
        hmi=$(echo $rl | cut -d/ -f3)
        rg=$(echo $rl | cut -d/ -f5)
        name=$(echo $rl | cut -d/ -f9)
        sub=${Laks[$hmi]}
        
        az vm show --name $name --subscription $sub --resource-group $rg --query storageProfile.dataDisks[*].managedDisk.id -o tsv > datadisks.txt
        az vm show --name $name --subscription $sub --resource-group $rg --query storageProfile.osDisk.managedDisk.id -o tsv > osdisks.txt      
        
        while read -r liner
        do
        dname=$liner
        az tag update --subscription $sub --resource-id $dname --operation merge --tags "$key"="$value" --query "id" | rev | cut -d/ -f5 | rev
        done < "$input1"

        while read -r linel
        do
        oname=$linel
        az tag update --subscription $sub --resource-id $oname --operation merge --tags "$key"="$value" --query "id" | rev | cut -d/ -f5 | rev
        done < "$input2"

done < "$input"

