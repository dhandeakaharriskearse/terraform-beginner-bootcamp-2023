output "bucket_name" {
  description = "Bucket Name for our static website hosting"
  value = module.terrahouse_aws.bucket_name
}