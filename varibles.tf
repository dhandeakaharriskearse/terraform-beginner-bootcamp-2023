variable "terratowns_access_token" {
  type = string
}
variable "terratowns_endpoint" {
  type = string
}
variable "teacherseat_user_uuid" {
  type = string
}
variable "rum_cake" {
   type = object({
    public_path = string
    content_version = number
  })
}
variable "baja_blast" {
  type = object({
    public_path = string
    content_version = number
  })
}
