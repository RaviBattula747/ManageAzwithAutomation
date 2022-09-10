declare -A Laks
Laks[f63fa6ca-967f-4ff6-8e38-************]="N$NTM$DI$-NP—01"
Laks[74fc6867-eae0-4eb9-9a87-************]="N$NTM$DI$-PRD—01"
Laks[307229a7-f578-4e4c-b96e-************]="N$NTM$DI$-SANDBOX-01"
Laks[b3f964c7-1d16-4c8d-8240-************]="N$NTM$DI$-SS—01"
Laks[1bffd3a8-c19d-4216-be31-************]="N$NTM$DI$-VDI-01"

input="/home/ravi/ManageAzwithAutomation/UpdateTag/nicInheritVmTag/inputFile.txt"
input1="/home/ravi/ManageAzwithAutomation/UpdateTag/nicInheritVmTag/nics.txt"
key="Application Name"

while read -r lines
do
        value=$(echo $lines | cut -d, -f1)
        rl=$(echo $lines | cut -d, -f2)
        hmi=$(echo $rl | cut -d/ -f3)
        rg=$(echo $rl | cut -d/ -f5)
        name=$(echo $rl | cut -d/ -f9)
        sub=${Laks[$hmi]}
        az vm show --name $name --subscription $sub --resource-group $rg --query networkProfile.networkInterfaces[*].id -o tsv > nics.txt
while read -r liner
        do
        nicname=$liner
        az tag update --subscription $sub --resource-id $nicname --operation merge --tags "$key"="$value" --query "id" | rev | cut -d/ -f5 | rev
        done < "$input1"

        done < "$input"