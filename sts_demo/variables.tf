variable "project_id" {
  description = "The ID of the project"
  type        = string
}

variable "region_id" {
  description = "The region"
  type        = string
}

variable "zone_id" {
  description = "The zone"
  type        = string
}

variable "gcs_sa" {
  description = "built-in service account of GCS"
  type        = string
}

variable "sts_sa" {
  description = "built-in service account of Storage Transfer serivce"
  type        = string
}
