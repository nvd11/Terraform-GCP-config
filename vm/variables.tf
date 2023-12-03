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

variable "vpc" {
  description = "vpc network name"
  type        = string
}

variable "subnet" {
  description = "vpc sub network name"
  type        = string
}