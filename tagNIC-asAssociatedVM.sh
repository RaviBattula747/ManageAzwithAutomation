declare -A Laks
Laks[f63fa6ca-967f-4ff6-8e38-554feccee894]="NANTMEDIA-NP—01"
Laks[74fc6867-eae0-4eb9-9a87-b89164d250dd]="NANTMEDIA-PRD—01"
Laks[307229a7-f578-4e4c-b96e-522183580ae3]="NANTMEDIA-SANDBOX-01"
Laks[b3f964c7-1d16-4c8d-8240-dd1b6a30a429]="NANTMEDIA-SS—01"
Laks[1bffd3a8-c19d-4216-be31-6461c03d2180]="NANTMEDIA-VDI-01"

input="/home/ravi_battula/file143lr.txt"
input1="/home/ravi_battula/file143nic.txt"
key="Application Name"

while read -r lines
do
        value=$(echo $lines | cut -d, -f1)
        rl=$(echo $lines | cut -d, -f2)
        hmi=$(echo $rl | cut -d/ -f3)
        rg=$(echo $rl | cut -d/ -f5)
        name=$(echo $rl | cut -d/ -f9)
        sub=${Laks[$hmi]}
        #echo $rg
        az vm show --name $name --subscription $sub --resource-group $rg --query networkProfile.networkInterfaces[*].id -o tsv > file143nic.txt
while read -r liner
        do
        nicname=$liner
        az tag update --subscription $sub --resource-id $nicname --operation merge --tags "$key"="$value" --query "id" | rev | cut -d/ -f5 | rev
        done < "$input1"

        done < "$input"