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
  cloud {
    organization = "Dhandeaka_HarrisKearse"
    workspaces {
      name = "terra-house-1"
    }
  }
}

provider "terratowns" {
  endpoint = var.terratowns_endpoint
  user_uuid= var.teacherseat_user_uuid
  token= var.terratowns_access_token
}

module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  teacherseat_user_uuid = var.teacherseat_user_uuid
  terratowns_access_token = var.terratowns_access_token
  terratowns_endpoint = var.terratowns_endpoint
  bucket_name = var.bucket_name
  index_html_filepath = var.index_html_filepath
  error_html_filepath = var.error_html_filepath
  content_version = var.content_version
  assets_path = var.assets_path
}

resource "terratowns_home" "home"{
  name = "A bomb recipe for rum cake!"
  description = <<DESCRIPTION
  This is a recipe I got from a friend's Grandmother. Don't tell her I'm giving this to you!
DESCRIPTION
  domain_name = module.terrahouse_aws.cloudfront_url
  town = "missingo"
  content_version = 1
}

module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  teacherseat_user_uuid = var.teacherseat_user_uuid
  terratowns_access_token = var.terratowns_access_token
  terratowns_endpoint = var.terratowns_endpoint
  bucket_name = var.bucket_name
  index_html_filepath = var.index_html_filepath
  error_html_filepath = var.error_html_filepath
  content_version = var.content_version
  assets_path = var.assets_path
}

resource "terratowns_home" "home"{
  name = "Make Your Own Baja Blast"
  description = <<DESCRIPTION
  The Taco Bell Cartel has a stranglehold on the heavenly nectar that is Mountain Dew Baja Blast.
After lots of trial and error and much frustration I've discovered the recipe. And,
it's easier than you think.
DESCRIPTION
  domain_name = module.terrahouse_aws.cloudfront_url
  town = "missingo"
  content_version = 1
}