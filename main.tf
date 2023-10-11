terraform {
required_providers {
  terratowns ={
    source = "local.providers/local/terratowns"
    version = "1.0.0"
  }
}

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

provider "terratowns" {
  endpoint = "http://localhost:4567/api"
  user_uuid="e328f4ab-b99f-421c-84c9-4ccea042c7d1" 
  token="9b49b3fb-b8e9-483c-b703-97ba88eef8e0"
}

# module "terrahouse_aws" {
#   source = "./modules/terrahouse_aws"
#   user_uuid = var.user_uuid
#   bucket_name = var.bucket_name
#   index_html_filepath = var.index_html_filepath
#   error_html_filepath = var.error_html_filepath
#   content_version = var.content_version
#   assets_path = var.assets_path
# }

resource "terratowns_home" "home"{
  name = "A bomb recipe for rum cake!"
  description = <<DESCRIPTION
  This is a recipe I got from a friend's Grandmother. Don't tell her I'm giving this to you!
DESCRIPTION
  #domain_name = module.terrahous_aws.cloudfront_url
  domain_name = "3fh59gz.cloudfront.net"
  town = "cooker-cove"
  content_version = 1
}

