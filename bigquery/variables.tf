variable "project_id" {
  description = "The ID of the project"
  type        = string
}

variable "region_id" {
  description = "The region"
  type        = string
}

variable "fluentd_ingress_email" {
  description = "the service account of fluentd"
  type        = string
}