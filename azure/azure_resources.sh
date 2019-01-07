#!/bin/bash
# -*- tab-width: 4; indent-tabs-mode: nil; -*-
set -e -o pipefail


echo "1. Azure - SUBSCRIPTION_ID is $1"
# echo "2. MySQL - RESOURCE_GROUP_NAME is $2"
# echo "3. AKS - CLUSTER_NAME is $3"
# echo "4. Azure - DNS_NAME is $4"
# echo "5. Azure - LOCATION is $5"

repo_root="$( cd . "$(dirname "$0")" ; pwd -P )"

AKS_VERSION=1.11.3
AKS_NODE_COUNT=3
AKS_MACHINE_TYPE=Standard_DS2_v2
SERVICE_CIDR=10.90.50.0/24 #test need to be run to check if cidr is available
DNS_SERVICE_IP=10.98.20.10
DOCKER_IP=172.17.0.1/16


# subscription_id="$1"
subscription_id=360afc1e-3ed0-46fd-982b-038ca352b438

function set_subscription() {
    echo "Setting subscription....."
    set_subscription=$(az account set --subscription $subscription_id)
}

echo "Azure resource script is now in action....."

#config/service_principle/service_principle_config.json

function create_service_principal() {
    echo "Creating Service Principal....."

    service_principal_config=$repo_root/config/service_principal/service_principal_config.json
    
    create_service_principal=$(az ad sp create-for-rbac --role "Owner" --scopes "/subscriptions/${subscription_id}/resourceGroups/${resource_group_name}")

    echo $create_service_principal > $service_principal_config
    echo "Finished Creating Service Principal....."
}
create_service_principal



function create_aks() {
    echo "Creating AKS....."

    aks_config=$repo_root/config/aks/aks_config.json
    service_principal_config=$repo_root/config/service_principal/service_principal_config.json

    service_principal_id=$(jq -re '.appId' "$service_principal_config")
    client_secret=$(jq -re '.password' "$service_principal_config")
    echo $service_principal_id
    echo $client_secret
    create_aks=$(az aks create --name ${resource_group_name} --resource-group ${resource_group_name} --kubernetes-version ${AKS_VERSION} --dns-name-prefix ${resource_group_name} --network-plugin azure --node-count ${AKS_NODE_COUNT} --vnet-subnet-id "/subscriptions/${subscription_id}/resourceGroups/${resource_group_name}/providers/Microsoft.Network/virtualNetworks/${resource_group_name}/subnets/${resource_group_name}" --workspace-resource-id "/subscriptions/${subscription_id}/resourceGroups/${resource_group_name}/providers/Microsoft.OperationalInsights/workspaces/${resource_group_name}" --node-vm-size ${AKS_MACHINE_TYPE} --service-cidr ${SERVICE_CIDR} --service-principal $service_principal_id --client-secret $client_secret --dns-service-ip ${DNS_SERVICE_IP} --docker-bridge-address ${DOCKER_IP} --generate-ssh-keys --enable-addons monitoring)

    echo $create_aks > $aks_config
    echo "Finished Creating AKS....."
}



function create_secrets() {
    echo "Creating Secrets in Keyvault....."

    object_id=$(jq -re '.appId' "$service_principal_config")
    client_secret=$(jq -re '.password' "$service_principal_config")
    tenant_id=$(jq -re '.tenant' "$service_principal_config")

    echo "Creating object_id Secrets in Keyvault..... $object_id"
    # create_object_id_secret=$(az keyvault secret set --name objectID --vault-name $resource_group_name --value $object_id)
    
    echo "Creating client_secret in Keyvault..... $client_secret"
    # create_client_secret=$(az keyvault secret set --name clientSecret --vault-name $resource_group_name --value $client_secret)
    
    echo "Creating tenant_id Secrets in Keyvault..... $tenant_id"
    # create_tenant_id_secret=$(az keyvault secret set --name tenantID --vault-name $resource_group_name --value $tenant_id)    
}
create_secrets


function create_static_ip() {
    echo "Creating Public Static IP......."

    static_ip_config=$repo_root/config/static_ip/static_ip_config.json
    
    create_static_ip=$(az network public-ip create --name ${resource_group_name} --resource-group MC_${resource_group_name}_${resource_group_name}_${location} --dns-name ${resource_group_name} --allocation-method Static )

    echo $create_static_ip > $static_ip_config
    echo "Finished Creating Public Static IP....."
}
#create_static_ip