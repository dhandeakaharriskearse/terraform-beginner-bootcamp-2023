variable "user_uuid" {
 type = string
}

variable "bucket_name" {
 description = "The name of the s3 bucket"   
 type = string

 validation {
   condition = (
    length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63 && 
    can(regex("^[a-z0-9][a-z0-9-.]*[a-z0-9]$", var.bucket_name))
   )
   error_message = "The bucket name must be between 3 and 63 characters"
 }
}

variable "index_html_filepath" {
  description = "Path to the index.html file"
  type        = string

  validation {
    condition     = fileexists(var.index_html_filepath)
    error_message = "The specified index_html_filepath does not exist or is not a valid file path."
  }
}

variable "error_html_filepath" {
  description = "Path to the error.html file"
  type        = string

  validation {
    condition     = fileexists(var.error_html_filepath)
    error_message = "The specified error_html_filepath does not exist or is not a valid file path."
  }
}

# variable "content_version" {
#   type        = number
# }

# variable "assets_path" {
#   description = "Path to assets folder"
#   type = string
# }