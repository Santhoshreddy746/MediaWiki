#!/bin/bash

# Create a resource group.
az group create --name MediaWiki --location eastus

# Create a virtual network.
az network vnet create --resource-group MediaWiki --name mwVnet --subnet-name mwSubnet

# Create a public IP address.
az network public-ip create --resource-group MediaWiki --name mwPublicIP

# Create a network security group.
az network nsg create --resource-group MediaWiki --name mwNetworkSecurityGroup

# Create a virtual network card and associate with public IP address and NSG.
az network nic create \
  --resource-group MediaWiki \
  --name mwNic \
  --vnet-name mwVnet \
  --subnet mwSubnet \
  --network-security-group mwNetworkSecurityGroup \
  --public-ip-address mwPublicIP

# Create a virtual machine, this creates SSH keys if not present.
az vm create \
    --resource-group MediaWiki \
    --name mwVM \
    --location eastus \
    --nics mwNic \
    --image UbuntuLTS \
    --admin-username azureuser \
    --admin-password Azure@123456 \
    --generate-ssh-keys

# Open port 80 to allow web traffic to host.
az vm open-port --port 80 --resource-group MediaWiki --name mwVM


# Use CustomScript extension to install NGINX.
az vm extension set \
  --publisher Microsoft.Azure.Extensions \
  --version 2.0 \
  --name CustomScript \
  --vm-name mwVM \
  --resource-group MediaWiki \
  --settings '{"fileUris":["https://raw.githubusercontent.com/Santhoshreddy746/MediaWiki/master/install_mediawiki.sh"],"commandToExecute":"sh install_mediawiki.sh"}'