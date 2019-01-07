#!/bin/bash
# -*- tab-width: 4; indent-tabs-mode: nil; -*-
set -e -o pipefail


echo "1. Azure - SUBSCRIPTION_ID is $1"
echo "2. MySQL - RESOURCE_GROUP_NAME is $2"
echo "3. AKS - CLUSTER_NAME is $3"
# echo "4. Azure - DNS_NAME is $4"
# echo "5. Azure - LOCATION is $5"

repo_root="$( cd . "$(dirname "$0")" ; pwd -P )"


#Resource Group Terraform
terraform init modules/resource_group/
terraform plan --out planfile -var resource_group_name=${resource_group_name} -var environment=${environment} -var location=${location} -state="$repo_root/config/resource_group/infra.tfstate" modules/resource_group/
terraform apply -state-out="$repo_root/config/resource_group/infra.tfstate" planfile
mv "$repo_root/planfile" "$repo_root/config/resource_group/"

#Create Service Principal
function create_service_principal() {
    echo "Creating Service Principal....."

    service_principal_config=$repo_root/config/service_principal/service_principal_config.json
    
    create_service_principal=$(az ad sp create-for-rbac --role "Owner" --scopes "/subscriptions/${subscription_id}/resourceGroups/${resource_group_name}")

    echo $create_service_principal > $service_principal_config
    echo "Finished Creating Service Principal....."
}
create_service_principal()

#MySQL Terraform @s@Def34do££V24sa
terraform init modules/mysql/
terraform plan --out planfile -var password=${password} -var resource_group_name=${resource_group_name} -var environment=${environment} -var location=${location} -state="$repo_root/config/mysql/infra.tfstate" modules/mysql/
terraform apply -state-out="$repo_root/config/mysql/infra.tfstate" planfile
mv "$repo_root/planfile" "$repo_root/config/mysql/"

# rm -rf "$repo_root/planfile"
#Storage Account Terraform
terraform init modules/storage_account/
terraform plan --out planfile -var resource_group_name=${resource_group_name} -var environment=${environment} -var location=${location} -state="$repo_root/config/storage_account/infra.tfstate" modules/storage_account/
terraform apply -state-out="$repo_root/config/storage_account/infra.tfstate" planfile
mv "$repo_root/planfile" "$repo_root/config/storage_account/"

#OMS Log Analytics Terraform
# terraform init modules/oms_loganalytics/
# terraform plan --out planfile -var resource_group_name=${resource_group_name} -var environment=${environment} -var location=${location} -var password=${password} -state="$repo_root/config/oms_loganalytics/infra.tfstate" modules/oms_loganalytics/
# terraform apply -state-out="$repo_root/config/oms_loganalytics/infra.tfstate" planfile
# mv "$repo_root/planfile" "$repo_root/config/oms_loganalytics/"

#VNET Terraform
terraform init modules/virtual_network/
terraform plan --out planfile -var resource_group_name=${resource_group_name} -var environment=${environment} -var location=${location} -var subscription_id=${subscription_id} -state="$repo_root/config/virtual_network/infra.tfstate" modules/virtual_network/
terraform apply -state-out="$repo_root/config/virtual_network/infra.tfstate" planfile
mv "$repo_root/planfile" "$repo_root/config/virtual_network/"

#Keyvault Terraform
terraform init modules/keyvault/
terraform plan --out planfile -var resource_group_name=${resource_group_name} -var environment=${environment} -var location=${location} -var subscription_id=${subscription_id} -var tenant_id=${tenant_id} -var object_id=${object_id} -state="$repo_root/config/keyvault/infra.tfstate" modules/keyvault/
terraform apply -state-out="$repo_root/config/keyvault/infra.tfstate" planfile
mv "$repo_root/planfile" "$repo_root/config/keyvault/"

#Get parameters from Service Principle config file (config/service_principle/service_principle_config.json) and create secrets in Keyvault
function create_secrets() {
    echo "Creating Secrets in Keyvault....."

    object_id=$(jq -re '.appId' "$service_principal_config")
    client_secret=$(jq -re '.password' "$service_principal_config")
    tenant_id=$(jq -re '.tenant' "$service_principal_config")

    echo "Creating object_id Secrets in Keyvault..... $object_id"
    create_object_id_secret=$(az keyvault secret set --name objectID --vault-name $resource_group_name --value $object_id)
    
    echo "Creating client_secret in Keyvault..... $client_secret"
    create_client_secret=$(az keyvault secret set --name clientSecret --vault-name $resource_group_name --value $client_secret)
    
    echo "Creating tenant_id Secrets in Keyvault..... $tenant_id"
    create_tenant_id_secret=$(az keyvault secret set --name tenantID --vault-name $resource_group_name --value $tenant_id)    
}
#create_secrets
