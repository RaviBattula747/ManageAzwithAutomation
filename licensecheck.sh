input="/home/ravi/input.txt"
while read -r line
do

az vm show --ids $line --query [storageProfile.osDisk.osType,licenseType,name] -o tsv >> sysgenout1.txt

done < "$input"
