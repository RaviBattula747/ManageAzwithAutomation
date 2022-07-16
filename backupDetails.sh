
input1="/home/ravi_battula/datadisks.txt"
while read -r liner
        do
        ddId=$liner
        az backup policy list-associated-items --subscription NANTMEDIA-ss—01 --resource-group rg-bck-ss-01 --vault-name rsv-wus-ss-01 --name $ddId --query [].[properties.policyName,properties.friendlyName] -o tsv >> output.txt


done < "$input1"
