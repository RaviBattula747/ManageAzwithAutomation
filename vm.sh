#!/bin/sh
if [ $1 == "1" ]
then
az vm create -n vm-ntw-q1-poc-spoke01-ci-01 -g rg-ntw-q1-poc-ci-01 -l centralindia --computer-name spoke01-ci-01 --image=win2019DataCenter --size standard_b1ms --admin-username "tcsntw" --admin-password "Tcsntw@12341234" --private-ip-address "10.4.1.5" --public-ip-address "" --nsg "" --vnet-name "vnet-ntw-q1-poc-spoke-ci-01" --subnet "snet-ntw-q1-poc-spoke-ci-01" --os-disk-delete-option delete --nic-delete-option delete
#az vm create -n vm-ntw-q1-poc-spoke01-ci-02 -g rg-ntw-q1-poc-ci-01 -l centralindia --computer-name spoke01-ci-02 --image=win2019DataCenter --size standard_b1ms --admin-username "tcsntw" --admin-password "Tcsntw@12341234" --private-ip-address "10.4.1.6" --public-ip-address ""  --nsg "" --vnet-name "vnet-ntw-q1-poc-spoke-ci-01" --subnet "snet-ntw-q1-poc-spoke-ci-01" --os-disk-delete-option delete --nic-delete-option delete
#az vm create -n vm-ntw-q1-poc-spoke02-ci-01 -g rg-ntw-q1-poc-ci-01 -l centralindia --computer-name spoke02-ci-01 --image=win2019DataCenter --size standard_b1ms --admin-username "tcsntw" --admin-password "Tcsntw@12341234" --private-ip-address "10.4.2.4" --public-ip-address ""  --nsg "" --vnet-name "vnet-ntw-q1-poc-spoke-ci-02" --subnet "snet-ntw-q1-poc-spoke-ci-02" --os-disk-delete-option delete --nic-delete-option delete
#az vm create -n vm-ntw-q1-poc-spoke01-si-01 -g rg-ntw-q1-poc-si-01 -l southindia --computer-name spoke01-si-01 --image=win2019DataCenter --size standard_b1ms --admin-username "tcsntw" --admin-password "Tcsntw@12341234" --private-ip-address "10.5.1.4" --public-ip-address ""  --nsg "" --vnet-name "vnet-ntw-q1-poc-spoke-si-01" --subnet "snet-ntw-q1-poc-spoke-si-01" --os-disk-delete-option delete --nic-delete-option delete

./IISinstall.ps1

else
az vm delete -n vm-ntw-q1-poc-spoke01-ci-01 -g rg-ntw-q1-poc-ci-01 --yes
#az vm delete -n vm-ntw-q1-poc-spoke01-ci-02 -g rg-ntw-q1-poc-ci-01 --yes
#az vm delete -n vm-ntw-q1-poc-spoke02-ci-01 -g rg-ntw-q1-poc-ci-01 --yes
#az vm delete -n vm-ntw-q1-poc-spoke01-si-01 -g rg-ntw-q1-poc-si-01 --yes
fi

