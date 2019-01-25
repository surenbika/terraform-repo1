# Project to create environment in azure

1. Update default variable file for each module in terraform/modules for required environment

2. Create a copy of terraform/terraform-export-dev for required environment to include appropriate values

3. Run following commands
cd terraform
source terraform-export-<environment>
./azure/azure.sh

Please note when updating the default variable files, use incremental IP address for CIDR, Vnet and Subnet
