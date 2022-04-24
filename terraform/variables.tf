variable "project_id" {
  description = "The project id where infra will be actuated."
  type        = string
}

variable "cloud_run_location" {
  description = <<EOT
    The location for the cloud run service:
    https://cloud.google.com/run/docs/locations
  EOT
  type        = string
  default     = "northamerica-northeast1"
}

variable "config_mount_path" {
  description = "The path to the location where domo config will be mounted."
  type        = string
}

variable "config_file_name" {
  description = "The file name for the domo config file."
  type        = string
}
