variable "teacherseat_user_uuid" {
  description = "The UUID of the user"
 type = string
 
 validation {
   condition = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.teacherseat_user_uuid))
   error_message = "The user_uuid is not a valid UUID"
 }
}

# variable "bucket_name" {
#  description = "The name of the s3 bucket"   
#  type = string

#  validation {
#    condition = (
#     length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63 && 
#     can(regex("^[a-z0-9][a-z0-9-.]*[a-z0-9]$", var.bucket_name))
#    )
#    error_message = "The bucket name must be between 3 and 63 characters"
#  }
# }

variable "content_version" {
  type        = number
  description = "The version number for your content (positive integer starting at 1)"

  validation {
    condition     = var.content_version >= 1 && ceil(var.content_version) == var.content_version
    error_message = "content_version must be a positive integer starting at 1."
  }
}

variable "public_path" {
  description = "The file path for the public directory"
  type        = string
}