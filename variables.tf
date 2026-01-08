variable "region" {
  type    = string
  default = "europe-west1"
}

variable "org_id" {
  type    = string
  default = null
}

variable "folder_id" {
  type    = string
  default = null
}

variable "billing_account" {
  type = string
}

variable "project_name_prefix" {
  type    = string
  default = "iam-privesc-lab"
}

variable "existing_project_id" {
  type    = string
  default = null
}

variable "bootstrap_user" {
  type = string
}

variable "enable_path_sa_key_create" {
  type    = bool
  default = true
}

variable "enable_path_set_iam_policy" {
  type    = bool
  default = true
}

variable "enable_path_custom_role_update" {
  type    = bool
  default = true
}

variable "enable_storage_targets" {
  type    = bool
  default = true
}
