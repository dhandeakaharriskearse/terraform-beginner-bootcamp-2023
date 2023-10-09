terraform {
  # backend "remote" {
  #   hostname = "app.terraform.io"
  #   organization = "Dhandeaka_HarrisKearse"
  #   workspaces {
  #     name = "terra-house-week-0"
  #   }
  # }
  # cloud {
  #   organization = "Dhandeaka_HarrisKearse"
  #   workspaces {
  #     name = "terra-house-week-0"
  #   }
  # }
}

module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}