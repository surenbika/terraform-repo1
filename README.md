# Project to create environment in azure

1. Update variable file for each module in terraform/modules for required environment

2. Create a copy of terraform/terraform-export-dev for required environment

3. Run following commands
cd terraform
source terraform-export-<environment>
./azure/azure.sh
