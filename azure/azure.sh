#!/bin/bash
# -*- tab-width: 4; indent-tabs-mode: nil; -*-
set -e -o pipefail

# echo "1. Azure - SUBSCRIPTION_ID is $1"
# echo "2. MySQL - RESOURCE_GROUP_NAME is $2"
# echo "3. AKS - CLUSTER_NAME is $3"
# echo "4. Azure - DNS_NAME is $4"
# echo "5. Azure - LOCATION is $5"

repo_root="$( cd . "$(dirname "$0")" ; pwd -P )"

source "$repo_root/azure/helper.sh"

declare RESOURCE_GROUP_NAME ENVIRONMENT LOCATION

AKS_VERSION=1.11.5
AKS_NODE_COUNT=3
AKS_MACHINE_TYPE=Standard_DS2_v2
DNS_SERVICE_IP=10.98.20.10 #DON NOT CHANGE
DOCKER_IP=172.17.0.1/16 #DON NOT CHANGE
START_IP_ADDRESS=213.249.255.154
END_IP_ADDRESS=213.249.255.154

##TODO
#Ensure all inputs are lowercase


#Authenticate Azure CLI
function authenticate_cli() {
    echo "Authenticating user against Azure CLI....."
    authenticate_cli=$(az login -u $USERNAME -p $USER_PASSWORD)
}
authenticate_cli

#Set Azure Subscription
function set_subscription() {
    echo "Setting subscription....."
    set_subscription=$(az account set --subscription $SUBSCRIPTION_ID)
}
set_subscription

#Create Resource Group
function create_resource_group() {
    echo "Creating Resource Group....."

    #Resource Group Terraform
    terraform init modules/resource_group/
    terraform plan --out planfile -var resource_group_name=${RESOURCE_GROUP_NAME} -var environment=${ENVIRONMENT} -var location=${LOCATION} -state="$repo_root/config_${ENVIRONMENT}/resource_group/infra.tfstate" modules/resource_group/
    terraform apply -state-out="$repo_root/config_${ENVIRONMENT}/resource_group/infra.tfstate" planfile
    mv "$repo_root/planfile" "$repo_root/config_${ENVIRONMENT}/resource_group/"

    echo "Finished Creating Resource Group....."
}
create_resource_group

#Create Service Principal
function create_service_principal() {
    echo "Creating Service Principal....."

    if [ ! -d "$repo_root/config_${ENVIRONMENT}/service_principal" ]; then
        mkdir $repo_root/config_${ENVIRONMENT}/service_principal
    fi
        service_principal_config=$repo_root/config_${ENVIRONMENT}/service_principal/service_principal_config.json

        create_service_principal=$(az ad sp create-for-rbac --role "Owner" --scopes "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_NAME}")

        echo $create_service_principal > $service_principal_config
        echo "Finished Creating Service Principal....."
}
create_service_principal

#Create Infra
function main() {

    echo "Creating Infra....."
    #MySQL Terraform @s@Def34do££V24sa
    terraform init modules/mysql/
    terraform plan --out planfile -var password=${PASSWORD} -var resource_group_name=${RESOURCE_GROUP_NAME} -var environment=${ENVIRONMENT} -var location=${LOCATION} -state="$repo_root/config_${ENVIRONMENT}/mysql/infra.tfstate" modules/mysql/
    terraform apply -state-out="$repo_root/config_${ENVIRONMENT}/mysql/infra.tfstate" planfile
    mv "$repo_root/planfile" "$repo_root/config_${ENVIRONMENT}/mysql/"

    # rm -rf "$repo_root/planfile"
    #Storage Account Terraform
    # terraform init modules/storage_account/
    # terraform plan --out planfile -var resource_group_name=${RESOURCE_GROUP_NAME} -var environment=${ENVIRONMENT} -var location=${LOCATION} -state="$repo_root/config_${ENVIRONMENT}/storage_account/infra.tfstate" modules/storage_account/
    # terraform apply -state-out="$repo_root/config_${ENVIRONMENT}/storage_account/infra.tfstate" planfile
    # mv "$repo_root/planfile" "$repo_root/config_${ENVIRONMENT}/storage_account/"

    # OMS Log Analytics Terraform
    terraform init modules/oms_loganalytics/
    terraform plan --out planfile -var resource_group_name=${RESOURCE_GROUP_NAME} -var environment=${ENVIRONMENT} -var location=${LOCATION} -var password=${PASSWORD} -state="$repo_root/config_${ENVIRONMENT}/oms_loganalytics/infra.tfstate" modules/oms_loganalytics/
    terraform apply -state-out="$repo_root/config_${ENVIRONMENT}/oms_loganalytics/infra.tfstate" planfile
    mv "$repo_root/planfile" "$repo_root/config_${ENVIRONMENT}/oms_loganalytics/"

    #VNET Terraform
    terraform init modules/virtual_network/
    terraform plan --out planfile -var resource_group_name=${RESOURCE_GROUP_NAME} -var environment=${ENVIRONMENT} -var location=${LOCATION} -var subscription_id=${SUBSCRIPTION_ID} -state="$repo_root/config_${ENVIRONMENT}/virtual_network/infra.tfstate" modules/virtual_network/
    terraform apply -state-out="$repo_root/config_${ENVIRONMENT}/virtual_network/infra.tfstate" planfile
    mv "$repo_root/planfile" "$repo_root/config_${ENVIRONMENT}/virtual_network/"

    object_id=$(jq -re '.appId' "$service_principal_config")
    tenant_id=$(jq -re '.tenant' "$service_principal_config")


    #Keyvault Terraform
    terraform init modules/keyvault/
    terraform plan --out planfile -var resource_group_name=${RESOURCE_GROUP_NAME} -var environment=${ENVIRONMENT} -var location=${LOCATION} -var subscription_id=${SUBSCRIPTION_ID} -var tenant_id=${tenant_id} -var object_id=${object_id} -state="$repo_root/config_${ENVIRONMENT}/keyvault/infra.tfstate" modules/keyvault/
    terraform apply -state-out="$repo_root/config_${ENVIRONMENT}/keyvault/infra.tfstate" planfile
    mv "$repo_root/planfile" "$repo_root/config_${ENVIRONMENT}/keyvault/"

    echo "Finished Creating Infra....."
}
main

#Get parameters from Service Principle config file (config_${ENVIRONMENT}/service_principle/service_principle_config.json) and create secrets in Keyvault
function create_secrets() {
    echo "Creating Secrets in Keyvault....."

    object_id=$(jq -re '.appId' "$service_principal_config")
    client_secret=$(jq -re '.password' "$service_principal_config")
    tenant_id=$(jq -re '.tenant' "$service_principal_config")

    echo "Creating object_id Secrets in Keyvault..... $object_id"
    # create_object_id_secret=$(az keyvault secret set --name objectID --vault-name $KEY_VAULT_NAME --value $object_id)

    echo "Creating client_secret in Keyvault..... $client_secret"
    # create_client_secret=$(az keyvault secret set --name clientSecret --vault-name $KEY_VAULT_NAME --value $client_secret)

    echo "Creating tenant_id Secrets in Keyvault..... $tenant_id"
    # create_tenant_id_secret=$(az keyvault secret set --name tenantID --vault-name $KEY_VAULT_NAME --value $tenant_id)

    echo "Finished Creating Secrets in Keyvault....."
}
create_secrets

#Deploy AKS
function create_aks() {
    echo "Creating AKS....."

    if [ ! -d "$repo_root/config_${ENVIRONMENT}/aks" ]; then
        mkdir $repo_root/config_${ENVIRONMENT}/aks
    fi
        aks_config=$repo_root/config_${ENVIRONMENT}/aks/aks_config.json
        service_principal_config=$repo_root/config_${ENVIRONMENT}/service_principal/service_principal_config.json

        service_principal_id=$(jq -re '.appId' "$service_principal_config")
        client_secret=$(jq -re '.password' "$service_principal_config")
        echo $service_principal_id
        echo $client_secret
        create_aks=$(az aks create --name ${AKS_NAME} --resource-group ${RESOURCE_GROUP_NAME} --kubernetes-version ${AKS_VERSION} --dns-name-prefix ${AKS_NAME} --network-plugin azure --node-count ${AKS_NODE_COUNT} --vnet-subnet-id "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_NAME}/providers/Microsoft.Network/virtualNetworks/${VIRTUAL_NETWORK_NAME}/subnets/${SUBNET_NAME}" --workspace-resource-id "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_NAME}/providers/Microsoft.OperationalInsights/workspaces/${LOG_WORKSPACE_NAME}" --node-vm-size ${AKS_MACHINE_TYPE} --service-cidr ${SERVICE_CIDR} --service-principal $service_principal_id --client-secret $client_secret --dns-service-ip ${DNS_SERVICE_IP} --docker-bridge-address ${DOCKER_IP} --generate-ssh-keys --enable-addons monitoring)

        # echo $create_aks > $aks_config
        echo "Finished Creating AKS....."
}
create_aks

#Create IP Address
function create_static_ip() {
    echo "Creating Public Static IP......."

    if [ ! -d "$repo_root/config_${ENVIRONMENT}/static_ip" ]; then
        mkdir $repo_root/config_${ENVIRONMENT}/static_ip
    fi
        static_ip_config=$repo_root/config_${ENVIRONMENT}/static_ip/static_ip_config.json

        create_static_ip=$(az network public-ip create --name ${PUBLIC_IP_NAME} --resource-group ${RESOURCE_GROUP_NAME} --dns-name ${PUBLIC_IP_NAME} --allocation-method Static )

        echo $create_static_ip > $static_ip_config
        echo "Finished Creating Public Static IP....."
}
create_static_ip
