
variable "name_prefix" {
  type        = string
  default     = "login-system"
  description = "Prefix to be used on each infrastructure object Name created in AWS."
}

variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "admin_users" {
  type        = list(string)
  default     = []
  description = "List of Kubernetes admins."
}

variable "developer_users" {
  type        = list(string)
  default     = []
  description = "List of Kubernetes developers."
}

variable "main_network_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "Base CIDR block to be used in our VPC."
}

variable "subnet_prefix_extension" {
  type        = number
  default     = 4
  description = "CIDR block bits extension to calculate CIDR blocks of each subnetwork."
}


variable "asg_sys_instance_types" {
  type        = list(string)
  default     = ["t3a.medium"]
  description = "List of EC2 instance machine types to be used in EKS for the system workload."
}

variable "asg_dev_instance_types" {
  type        = list(string)
  default     = ["t3a.medium"]
  description = "List of EC2 instance machine types to be used in EKS for development workload."
}