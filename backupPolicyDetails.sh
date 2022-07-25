

az backup policy list --resource-group rg-bck-prd-01 --vault-name rsv-wus-prd-01 --query [].name -o tsv >> policyList.txt

input1="/home/ravi_battula/policyList.txt"

while read -r liner

do
        ddId=$liner
        az backup policy list-associated-items --subscription NANTMEDIA-ss—01 --resource-group rg-bck-ss-01 --vault-name rsv-wus-ss-01 --name $ddId --query [].[properties.policyName,properties.friendlyName] -o tsv >> output.txt
done < "$input1"

--description
This code gives the output of all the poilicies in the  --vault-name with the mapping of "policy Name"  and its "Associated Items" 
