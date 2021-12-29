
variable "resource_group_name" {
  description = "name of the resource group"
  type = string
  
}

variable "location" {
  description = "location name"
  type = string
  
}

variable "virtual_network" {
  description = "virtual network name"
  type = string
  
}

variable "subnet" {
  description = "subnet name"
  default     = null
}

variable "endpoint" {
  description = "endpoint name"
  default     = null
}

variable "public_IP_name" {
  description = "public ip name"
  default     = null
}

variable "load_balancer" {
  description = "load balancer name"
  default     = null
}

variable "private_link" {
  description = "private link name"
  default     = null
}


variable "private_endpoint" {
  description = "private_endpoint link name"
  default     = null
}


variable "private_service_connection" {
  description = "private service connection link name"
  default     = null
}