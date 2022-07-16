input="/home/ravi_battula/file143.txt"
input1="/home/ravi_battula/datadisks.txt"
input2="/home/ravi_battula/osdisks.txt"

while read -r liner1
        do        
az vm show --ids $liner1 --query storageProfile.dataDisks[*].managedDisk.id -o tsv > datadisks.txt
az vm show --ids $liner1 --query storageProfile.osDisk.managedDisk.id -o tsv > osdisks.txt

while read -r liner
        do
        ddId=$liner
        az disk show --ids $ddId --query [name,diskSizeGb,diskIopsReadWrite,diskMBpsReadWrite] -o tsv >> resultforDiskSizes.txt
        done < "$input1"
while read -r liner
        do
        odId=$liner
        az disk show --ids $odId --query [name,diskSizeGb,diskIopsReadWrite,diskMBpsReadWrite] -o tsv >> resultforDiskSizes.txt
        done < "$input2"

done < "$input"

--description
* input your VM resource ID's into a empty txt file in my case "file143.txt" for which you want to know the properties of attached disks and give the file path to the variable "input" as the line1.
* create another 2 emptyfile and give the paths to input1 and input2 variabe, in my case empty files are datadisks.txt and osdisks.txt in line 2&3.
* in the same directory as this code file "diskDetails.sh" create another txt file - resultforDiskSizes.txt

get the output in resultforDiskSizes.txt.

Happy coding.
