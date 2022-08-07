#!/bin/bash
declare -A Lak
input="/home/ravi_battula/file143.txt"

#Lak[subscription_id]=subscription Name.

Lak[f63fa6ca-967f-4ff6-8e38-************]="NA#T₹E&IA-NP—01"
Lak[74fc6867-eae0-4eb9-9a87-************]="NA#T₹E&IA-PRD—01"
Lak[307229a7-f578-4e4c-b96e-************]="NA#T₹E&IA-SANDBOX-01"
Lak[b3f964c7-1d16-4c8d-8240-************]="NA#T₹E&IA-SS—01"
Lak[1bffd3a8-c19d-4216-be31-************]="NA#T₹E&IA-VDI-01"

  key="Application Name"
  while read -r lines
do
        value=$(echo $lines | cut -d, -f1)
        rl=$(echo $lines | cut -d, -f2)
        shmi=$(echo $rl | cut -d/ -f3)
        rg=$(echo $rl | cut -d/ -f5)
        name=$(echo $rl | cut -d/ -f9)
        sub=${Lak[$shmi]}
      
 
  az tag update --subscription ${Lak[$shmi]} --resource-id "$rl" --operation merge --tags "$key"="$value" --query "id" | rev | cut -d/ -f5 | rev
done < "$input"

Description
input should be provided as a file, here file143.txt.
this file inputs need to be in <Tag value>,ResourceID, Here I have given the Tag key as "Application Name" you can change it based on your requirement.
