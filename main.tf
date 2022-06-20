 terraform {
       backend "remote" {
         # The name of your Terraform Cloud organization.
         organization = "aswinrajan"

         # The name of the Terraform Cloud workspace to store Terraform state files in.
         workspaces {
           name = "az-sample-apps-azmon"
         }
       }
     }

module "cluster" {
  source = "./modules/appservice/"
}