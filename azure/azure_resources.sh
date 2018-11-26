#!/bin/bash
# -*- tab-width: 4; indent-tabs-mode: nil; -*-
set -e -o pipefail
# echo "SOURCE_CLUSTER_NAME is $@"
# echo "1. MySQL -  password is $1"
# echo "2. MySQL - resource_group_name is $2"
# echo "3. Keyvault - object_id is $3"
# echo "4. Keyvault - tenant_id is $4"

echo "1. Azure - SUBSCRIPTION_ID is $1"
echo "2. MySQL - RESOURCE_GROUP_NAME is $2"
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


SUBSCRIPTION_ID="$1"
RESOURCE_GROUP_NAME="$2"
CLUSTER_NAME="$3"
DNS_NAME="$4"
LOCATION="$5"

echo "Azure resource script is now in action....."


function create_service_principal() {
    echo "Creating Service Principal....."

    service_principal_config=$repo_root/service_principal_config.json
    #rm -rf $service_principal_config
    
    create_service_principal=$(az ad sp create-for-rbac --role "Owner" --scopes "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_NAME}")

    echo $create_service_principal > $service_principal_config
    
    echo "Finished Creating Service Principal....."
}
# create_service_principal


function create_aks() {
    echo "Creating AKS....."

    aks_config=$repo_root/aks_config.json
    #rm -rf $service_principal_config
    
    service_principal_id=$(jq -re '.appId' "$service_principal_config")
    client_secret=$(jq -re '.password' "$service_principal_config")
    echo $service_principal_id
    echo $client_secret
    create_aks=$(az aks create --name ${CLUSTER_NAME} --resource-group ${RESOURCE_GROUP_NAME} --kubernetes-version ${AKS_VERSION} --dns-name-prefix ${CLUSTER_NAME} --network-plugin azure --node-count ${AKS_NODE_COUNT} --vnet-subnet-id "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_NAME}/providers/Microsoft.Network/virtualNetworks/${CLUSTER_NAME}/subnets/${CLUSTER_NAME}" --workspace-resource-id "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_NAME}/providers/Microsoft.OperationalInsights/workspaces/${CLUSTER_NAME}" --node-vm-size ${AKS_MACHINE_TYPE} --service-cidr ${SERVICE_CIDR} --service-principal $service_principal_id --client-secret $client_secret --dns-service-ip ${DNS_SERVICE_IP} --docker-bridge-address ${DOCKER_IP} --generate-ssh-keys --enable-addons monitoring)

    echo $create_aks > $aks_config

    echo "Finished Creating AKS....."
}
create_aks


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