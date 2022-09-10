
declare -A Laks
Laks[f63fa6ca-967f-4ff6-8e38-************]="N$NTM$DIA-NP—01"
Laks[74fc6867-eae0-4eb9-9a87-************]="N$NTM$DIA-PRD—01"
Laks[307229a7-f578-4e4c-b96e-************="N$NTM$DIA-SANDBOX-01"
Laks[b3f964c7-1d16-4c8d-8240-************]="N$NTM$DIA-SS—01"
Laks[1bffd3a8-c19d-4216-be31-************]="N$NTM$DIA-VDI-01"

input="/home/ravi/ManageAzwithAutomation/UpdateTag/diskInheritVmTag/inputFile.txt"
input1="/home/ravi/ManageAzwithAutomation/UpdateTag/diskInheritVmTag/datadisks.txt"
input2="/home/ravi/ManageAzwithAutomation/UpdateTag/diskInheritVmTag/osdisks.txt"
key="Application Name"

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

Description
input should be provided as a file, here inputFile.txt.
inputFile file need to to have data in the form <Tag value>,ResourceIDofVM. which can be obtained 
from concating cells in exported excel from Azure with columns resourceID

#then associated DataDisks and Os disks will be automatically Identified by the code and the Tag will be applied.
#Here I have given the Tag key as "Application Name" you can change it based on your requirement.
