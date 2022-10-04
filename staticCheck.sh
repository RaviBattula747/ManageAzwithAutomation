# input.txt contains resourceID's of the VM's that need to be verified on IP address allocation type
# to get Resource ID's == manage columns --> add resource ID column and save --> export CSV
# copy resource ID column from exported CSV and paste it a file named input.txt in your system

input="/home/ravi/input.txt"

while read -r line
do
echo $line"---" | cut -d "/" -f9 | tr -d '\n'
az vm show --ids ${line} --query networkProfile.networkInterfaces[*].id -o tsv > sysgenout1.txt 
while read -r line2
do
az network nic show --ids ${line2} --query ipConfigurations[].privateIpAllocationMethod -o tsv
done < "sysgenout1.txt"

done < "$input" 

<<com
Sample output

sitrep---Static
cediploma---Static

com