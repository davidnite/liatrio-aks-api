variable "location" {
  description = "Azure region used for deployment"
  default = "Central US"
}

variable "prefix" {
  description = "Used for naming Azure resources"
  default = "friskydingo"
}

variable "appId" {
  description = "Azure Kubernetes Service Cluster service principal"
  sensitive = true
}

variable "password" {
  description = "Azure Kubernetes Service Cluster password"
  sensitive = true
}

variable "containerSource" {
  description = "URL for the container source code"
  default = "https://github.com/davidnite/liatrio-flask-api#main"
}

variable "sourcePAT" {
  description = "PAT for github container source code"
}