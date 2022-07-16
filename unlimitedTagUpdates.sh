#!/bin/bash
declare -A Lak
input="/home/ravi_battula/file143.txt"
Lak[f63fa6ca-967f-4ff6-8e38-554feccee894]="NANTMEDIA-NP—01"
Lak[74fc6867-eae0-4eb9-9a87-b89164d250dd]="NANTMEDIA-PRD—01"
Lak[307229a7-f578-4e4c-b96e-522183580ae3]="NANTMEDIA-SANDBOX-01"
Lak[b3f964c7-1d16-4c8d-8240-dd1b6a30a429]="NANTMEDIA-SS—01"
Lak[1bffd3a8-c19d-4216-be31-6461c03d2180]="NANTMEDIA-VDI-01"

#while read -r line;
#do
 #       rl=$line
      
  key="Application Name"
 # value="ADIT"
 # shmi=$(echo $rl | cut -d/ -f3)
  
  while read -r lines
do
        value=$(echo $lines | cut -d, -f1)
        rl=$(echo $lines | cut -d, -f2)
       # rl=$(echo $lines)
        shmi=$(echo $rl | cut -d/ -f3)
        rg=$(echo $rl | cut -d/ -f5)
        name=$(echo $rl | cut -d/ -f9)
        sub=${Lak[$shmi]}
      
 
  az tag update --subscription ${Lak[$shmi]} --resource-id "$rl" --operation merge --tags "$key"="$value" --query "id" | rev | cut -d/ -f5 | rev
done < "$input"
