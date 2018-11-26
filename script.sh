#!/bin/bash
# -*- tab-width: 4; indent-tabs-mode: nil; -*-
set -e -o pipefail
# echo "SOURCE_CLUSTER_NAME is $@"
echo "1. MySQL -  password is $1"
echo "2. MySQL - resource_group_name is $2"
echo "3. Keyvault - object_id is $3"
echo "4. Keyvault - tenant_id is $4"
echo "4. Azure - subscription is $4"
repo_root="$( cd "$(dirname "$0")" ; pwd -P )"

MYSQL_PASSWORD="$1"
RESOURCE_GROUP_NAME="$2"
TENANT_ID="$3"
OBJECT_ID="$4"
SUBSCRIPTION="$5"


SOURCE_CLUSTER_NAME="$1"
CLUSTER_LOCATION="$2"
GITHUB_TOKEN="$3"

#Resource Group

#MySQL
var.password
var.resource_group_name


#Storage Account 

#OMS Log Analytic

#Virtual Network (VNET) 


#Keyvault 
var.object_id
var.tenant_id