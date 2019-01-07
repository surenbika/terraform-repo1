#!/bin/bash
# -*- tab-width: 4; indent-tabs-mode: nil; -*-
set -e -o pipefail
# echo "SOURCE_CLUSTER_NAME is $@"
# echo "1. MySQL -  password is $1"
# echo "2. MySQL - resource_group_name is $2"
# echo "3. Keyvault - object_id is $3"
# echo "4. Keyvault - tenant_id is $4"

echo "1. Azure - subscription_id is $1"
echo "2. MySQL - resource_group_name is $2"
echo "3. AKS - CLUSTER_NAME is $3"
echo "4. Azure - DNS_NAME is $4"
echo "5. Azure - LOCATION is $5"

repo_root="$( cd "$(dirname "$0")" ; pwd -P )"

# MYSQL_PASSWORD="$1"
# TENANT_ID="$3"
# OBJECT_ID="$4"

AKS_VERSION=1.11.3
AKS_NODE_COUNT=3
AKS_MACHINE_TYPE=Standard_DS2_v2
SERVICE_CIDR=10.90.50.0/24 #test need to be run to check if cidr is available
DNS_SERVICE_IP=10.98.20.10
DOCKER_IP=172.17.0.1/16


# subscription_id="$1"
# resource_group_name="$2"
# CLUSTER_NAME="$3"
# DNS_NAME="$4"
# LOCATION="$4"

echo "Azure resource script is now in action....."


function create_service_principal() {
    echo "Creating Service Principal....."

    service_principal_config=$repo_root/service_principal_config.json
    
    create_service_principal=$(az ad sp create-for-rbac --role "Owner" --scopes "/subscriptions/${subscription_id}/resourceGroups/${resource_group_name}")

    echo $create_service_principal > $service_principal_config
    echo "Finished Creating Service Principal....."
}
# create_service_principal


function create_aks() {
    echo "Creating AKS....."

    aks_config=$repo_root/aks_config.json
    service_principal_config=$repo_root/service_principal_config.json

    service_principal_id=$(jq -re '.appId' "$service_principal_config")
    client_secret=$(jq -re '.password' "$service_principal_config")
    echo $service_principal_id
    echo $client_secret
    create_aks=$(az aks create --name ${resource_group_name} --resource-group ${resource_group_name} --kubernetes-version ${AKS_VERSION} --dns-name-prefix ${resource_group_name} --network-plugin azure --node-count ${AKS_NODE_COUNT} --vnet-subnet-id "/subscriptions/${subscription_id}/resourceGroups/${resource_group_name}/providers/Microsoft.Network/virtualNetworks/${resource_group_name}/subnets/${resource_group_name}" --workspace-resource-id "/subscriptions/${subscription_id}/resourceGroups/${resource_group_name}/providers/Microsoft.OperationalInsights/workspaces/${resource_group_name}" --node-vm-size ${AKS_MACHINE_TYPE} --service-cidr ${SERVICE_CIDR} --service-principal $service_principal_id --client-secret $client_secret --dns-service-ip ${DNS_SERVICE_IP} --docker-bridge-address ${DOCKER_IP} --generate-ssh-keys --enable-addons monitoring)

    echo $create_aks > $aks_config
    echo "Finished Creating AKS....."
}
create_aks
#bash -x azure/azure_resources.sh 360afc1e-3ed0-46fd-982b-038ca352b438 jermaine_goldencopy jermainegoldencopy


function create_secrets() {
    echo "Creating Secrets in Keyvault....."

    object_id=$(jq -re '.appId' "$service_principal_config")
    client_secret=$(jq -re '.password' "$service_principal_config")
    tenant_id=$(jq -re '.tenant' "$service_principal_config")

    create_object_id_secret=$(az keyvault secret set --name objectID --vault-name $resource_group_name --value $object_id)
    create_client_secret=$(az keyvault secret set --name clientSecret --vault-name $resource_group_name --value $client_secret)
    create_tenant_id_secret=$(az keyvault secret set --name tenantID --vault-name $resource_group_name --value $tenant_id)    
}

function create_static_ip() {
    echo "Creating Public Static IP......."

    service_principal_config=$repo_root/service_principal_config.json
    #rm -rf $service_principal_config
    
    create_service_principal=$(az network public-ip create --name ${CLUSTER_NAME} --resource-group MC_${RESOURCE_GROUP_NAME}_${RESOURCE_GROUP_NAME}_${LOCATION} --dns-name ${RESOURCE_GROUP_NAME} --allocation-method Static )
        az ad sp create-for-rbac --role "Owner" --scopes "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_NAME}")

    echo $create_service_principal > $service_principal_config
    echo "Finished Creating Public Static IP....."
}
#create_static_ip

# jq -re '.appId' "$service_principal_config"

# SUBSCRIPTION_ID
# 360afc1e-3ed0-46fd-982b-038ca352b438

# RESOURCE_GROUP_NAME
# jermaine_goldencopy


#DNS_NAME="jermainegoldencopy"

#az network vnet create --name jermainegoldencopy --resource-group jermaine_goldencopy --address-prefixes 10.90.49.0/24 --subnet-name jermainegoldencopy --subnet-prefix 10.90.49.0/24

#az network vnet create --name jermainegoldencopy --resource-group jermaine_goldencopy --address-prefixes 10.90.49.0/24 --subnet-name jermainegoldencopy --subnet-prefix 10.90.49.0/24
# SERVICE_CIDR=10.90.50.0/24 #test need to be run to check if cidr is available
# DNS_SERVICE_IP=10.98.20.10


#Resource Group Terraform
#terraform plan -var resource_group_name="jermainegoldencopy" -var environment="jermainegoldencopy" -var location="West Europe" modules/resource_group/
#terraform plan -var resource_group_name="jermainegoldencopy" -var environment="jermainegoldencopy" -var location="West Europe" -var subscription_id="360afc1e-3ed0-46fd-982b-038ca352b438"  modules/resource_group/

#MySQL Terraform
#terraform plan -var password="@Jermainegoldencopy12" -var resource_group_name="jermainegoldencopy" -var environment="jermainegoldencopy" -var location="West Europe" modules/mysql/

#Storage Account Terraform
#terraform plan -var resource_group_name="jermainegoldencopy" -var environment="jermainegoldencopy" -var location="West Europe" modules/storage_account/

#OMS Log Analytics Terraform
#terraform plan -var resource_group_name="jermainegoldencopy" -var environment="jermainegoldencopy" -var location="West Europe" modules/oms_loganalytics/

#OMS Log Analytics Terraform
#terraform plan -var resource_group_name="jermainegoldencopy" -var environment="jermainegoldencopy" -var location="West Europe" -var subscription_id="360afc1e-3ed0-46fd-982b-038ca352b438" modules/oms_loganalytics/

#Keyvault Terraform
#terraform plan -var resource_group_name="jermainegoldencopy" -var environment="jermainegoldencopy" -var location="West Europe" -var subscription_id="360afc1e-3ed0-46fd-982b-038ca352b438" -var tenant_id="8634d27a-013f-4953-b957-60fdb603213d" -var object_id="81afef9d-2ff9-4faf-a0f6-e87219e7bbaf" modules/keyvault/



# output "environment" {
#   value = "jermainegoldencopy"
# }

# output "resource_group_name" {
#  value = "jermainegoldencopy"
# }

# output "location" {
#  value = "West Europe"
# }

# output "subscription_id" {
#  value = "" #"FILL IN SUBSCRIPTION ID"
# }


    create_object_id_secret=$(az keyvault secret set --name objectID --vault-name $resource_group_name --value $object_id)
    create_client_secret=$(az keyvault secret set --name clientSecret --vault-name $resource_group_name --value $client_secret)
    create_tenant_id_secret=$(az keyvault secret set --name tenantID --vault-name $resource_group_name --value $tenant_id)    


az keyvault secret set --name objectID --vault-name $resource_group_name_two --value $object_id