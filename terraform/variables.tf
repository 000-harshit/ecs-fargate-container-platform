variable "aws_region" {
  description = "AWS region for the optional deployment."
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  type    = string
  default = "fargate-portfolio"
}

variable "vpc_cidr" {
  type    = string
  default = "10.20.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.20.1.0/24", "10.20.2.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.20.11.0/24", "10.20.12.0/24"]
}

variable "frontend_image" {
  description = "Full ECR image URI for the frontend container."
  type        = string
}

variable "backend_image" {
  description = "Full ECR image URI for the backend container."
  type        = string
}

variable "desired_count" {
  type    = number
  default = 1
}
