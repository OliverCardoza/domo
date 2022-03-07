variable "project_id" {
  description = "The project id where infra will be actuated."
  type        = string
}

variable "config_mount_path" {
  description = "The path to the location where domo config will be mounted."
  type        = string
}

variable "config_file_name" {
  description = "The file name for the domo config file."
  type        = string
}

