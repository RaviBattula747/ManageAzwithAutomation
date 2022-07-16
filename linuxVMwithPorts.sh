
az vm create \
--name ravi \
--subscription NANTMEDIA-SANDBOX-01 \
--resource-group vmrg \
--image "ubuntuLTS" \
--location eastus \
--admin-username vi_ch \
--admin-password User123234345 \
--size standard_B2ms \
--storage-sku Standard_LRS

az vm open-port --subscription NANTMEDIA-SANDBOX-01 --port 80,22,443 --resource-group vmrg --name ravi
