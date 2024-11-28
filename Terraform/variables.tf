variable "provider_credentials" {
  type = object({
    subscription_id  = string
    tenant_id        = string
    sp_client_id     = string
    sp_client_secret = string
  })
}

variable "resource_group_config" {
  type = object({
    name             = string
    location         = string
  })
}

variable "db_server_config" {
  type = object({
    name             = string
    user             = string
    password         = string
  })
}

variable "db_config" {
  type = object({
    name             = string
  })
}

variable "storage_account_config" {
  type = object({
    name             = string
  })
}

variable "storage_container_config" {
  type = object({
    name             = string
  })
}

variable "app_secret" {
  type = object({
    value            = string
  })
}

variable "app_config" {
  type = object({
    name             = string
  })
}




