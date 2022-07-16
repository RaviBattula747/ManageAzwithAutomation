#array[0,0]/[1,0]/[2,0] refers the server/host name
#array[0,1] refers the RG
#array[0,3] is nic name of that vm
#array[0,4] is the name of ipconfig

max=3
declare -A array
array[0,0]=CLWPOEWEB06-test
array[0,1]=rg-app-pci-windows-prd-01
array[CLWPOEWEB06-test]=10.75.50.60

array[1,0]=cllpdsicrnweb01-test
array[1,1]=rg-app-pci-linux-prd-01
array[cllpdsicrnweb01-test]=10.75.50.99

array[2,0]=CLWPASURAFS02-test
array[2,1]=rg-app-non-pci-windows-prd-01
array[CLWPASURAFS02-test]=10.75.50.88


for (( i=0 ; i<$max ; i++ ))
do
array[$i,3]=$(az vm show -g ${array[$i,1]} --name ${array[$i,0]} --query networkProfile.networkInterfaces[0].id -o tsv | cut -d/ -f9)
array[$i,4]=$(az network nic show -g ${array[$i,1]}  -n ${array[$i,3]} --query ipConfigurations[0].id -o tsv | cut -d/ -f11)
array[$i,5]=$(az network nic ip-config update -g ${array[$i,1]} --nic-name ${array[$i,3]} --name ${array[$i,4]} --private-ip-address ${array[${array[$i,0]}]} --query provisioningState)

if [[ ${array[$i,5]} == '"Succeeded"' ]]
then
echo "${array[$i,0]} is done"
else
echo "execution failed for ${array[$i,0]}"
fi
done

--Description
* I had an requirment in past where I need to ensure the migrated VM in azure should get some predefined IP Address. So I have developed this code. This code might get
"ip not free" message when all the VM's are of same subnet hence I would recoomend to execute the code with some higher IP Address like "*.*.*.200+" and then with the actual IP.
