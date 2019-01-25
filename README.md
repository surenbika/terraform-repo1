# Project to create environment in azure

1. Update default variable file for each module in terraform/modules for required environment

2. Create terraform/terraform-export-<environment_name> for required environment to include appropriate values as follows:
export LATIN1=latin1
export LATIN1_SWEDISH_CI=latin1_swedish_ci
export SERVICE_CIDR=<aks-service-cidr>
export ENVIRONMENT=dev
export LOCATION=westeurope
export LOGS_SOLUTION=Containers
export ADMINISTRATOR_LOGIN=devadmin
export PASSWORD=<mysql-admin-password>
export RESOURCE_GROUP_NAME=vanilladevpocresourcegroup
export AKS_NAME=vanilladevkubernetes
export VIRTUAL_NETWORK_NAME=vanilladevvirtualnetwork
export SUBNET_NAME=vanilladevsubnet
export PUBLIC_IP_NAME=vanilladevpublicip
export KEY_VAULT_NAME=vanilladevkeyvault
export LOG_WORKSPACE_NAME=vanilladevomsloganalytics
export SUBSCRIPTION_ID=<azure-subscription-id>
export TENANT_ID=<azure-tenant-id>
export OBJECT_ID=<azure-object-id>
export USERNAME=<azure-id>
export USER_PASSWORD=<azure-password>

3. Run following commands
cd terraform
source terraform-export-<environment_name>
./azure/azure.sh

Please note when updating the default variable files and terraform export file, use incremental IP address for CIDR, Vnet and Subnet
