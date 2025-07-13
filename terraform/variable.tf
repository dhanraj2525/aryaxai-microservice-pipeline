variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_name" {
  description = "AWS VPC Name"
  type        = string
  default     = "aryaxai-vpc"
}

variable "vpc_cidr" {
  description = "AWS VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  description = "VPC public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "private_subnets_cidr" {
  description = "VPC public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "aryaxai-eks"
}