variable "location" {
  description = "Azure region used for deployment"
  default = "Central US"
}

variable "prefix" {
  description = "Used for naming Azure resources"
  default = "friskydingo"
}

variable "containerSource" {
  description = "URL for the container source code"
  default = "https://github.com/davidnite/liatrio-flask-api#main"
}

variable "sourcePAT" {
  description = "PAT for github container source code"
}