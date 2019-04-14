variable "common_infra_resource_group" {
  type    = "string"
}

variable "common_infra_resource_group_location" {
  type    = "string"
}

variable "user_resource_group_base" {
  type    = "string"
}

variable "number_of_users" {
  type    = "string"
  default = "1"
}

variable "end_date_relative" {
  type    = "string"
  default = "240h"
}