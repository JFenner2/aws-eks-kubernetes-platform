variable "aws_region" {
  description = "AWS region used for Project 5 infrastructure"
  type        = string
  default     = "ap-southeast-2"
}

variable "project_name" {
  description = "Name used for Project 5 AWS resources"
  type        = string
  default     = "project5"
}

variable "vpc_cidr" {
  description = "CIDR block for the Project 5 VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)

  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private EKS subnets"
  type        = list(string)

  default = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]
}
