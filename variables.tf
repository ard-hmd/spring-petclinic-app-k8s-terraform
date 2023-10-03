variable "namespace" {
  description = "The namespace for the Helm release"
  type        = string
  default     = "qa"
}

variable "repository_prefix" {
  description = "The repository prefix for the Helm release"
  type        = string
  default     = "ardhmd"
}

variable "mysql_root_password" {
  description = "The MySQL root password."
  type        = string
  sensitive   = true
}
