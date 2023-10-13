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

module "home_rum_cake_hosting" {
  source = "./modules/terrahome_aws"
  teacherseat_user_uuid = var.teacherseat_user_uuid
  public_path = var.rum_cake.public_path
  content_version = var.rum_cake.content_version
}

resource "terratowns_home" "rum_cake"{
  name = "A bomb recipe for rum cake!"
  description = <<DESCRIPTION
  This is a recipe I got from a friend's Grandmother. Don't tell her I'm giving this to you!
DESCRIPTION
  domain_name = module.home_rum_cake_hosting.domain_name
  town = "missingo"
  content_version = var.rum_cake.content_version
}

module "home_baja_blast_hosting" {
  source = "./modules/terrahome_aws"
  teacherseat_user_uuid = var.teacherseat_user_uuid
  public_path = var.baja_blast.public_path
  content_version = var.baja_blast.content_version
}

resource "terratowns_home" "baja_blast"{
  name = "Make Your Own Baja Blast"
  description = <<DESCRIPTION
  The Taco Bell Cartel has a stranglehold on the heavenly nectar that is Mountain Dew Baja Blast.
After lots of trial and error and much frustration I've discovered the recipe. And,
it's easier than you think.
DESCRIPTION
  domain_name = module.home_baja_blast_hosting.domain_name
  town = "missingo"
  content_version = var.baja_blast.content_version

}