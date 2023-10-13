output "bucket_name" {
  description = "Bucket Name for our static website hosting"
  value = module.home_baja_blast_hosting.bucket_name
}

output "S3_website_endpoint" {
  description = "S3 static website hosting endpoint"
  value = module.home_baja_blast_hosting.bucket_name
}

output "cloudfront_url" {
  description = "The CloudFront Distribution Domain Name"
  value = module.home_baja_blast_hosting.domain_name
}