variable "aws_region" {
  description = "The AWS region to deploy the infrastructure in."
  type        = string
  default     = "us-west-2"
}

variable "vpc_id" {
  description = "The ID of the VPC the infrastructure will be deployed in."
  type        = string
}

variable "subnet_ids" {
  description = "The IDs of the subnets the infrastructure will be deployed in."
  type        = list(string)
}

variable "app_name" {
  description = "The name of the finance app."
  type        = string
  default     = "finance-app"
}
