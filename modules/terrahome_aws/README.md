## Terrahome AWS

```tf
module "home_baja_blast_hosting" {
  source = "./modules/terrahome_aws"
  teacherseat_user_uuid = var.teacherseat_user_uuid
  public_path = var.baja_blast.public_path
  content_version = var.baja_blast.content_version
}
```

THe public directory expects the following:
- index.html
- error.html
- assets

All top level files in assets will be copied, but not any subdirectories.