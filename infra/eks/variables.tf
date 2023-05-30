variable "region" {
  description = "The AWS region where the EKS cluster will be deployed"
  type        = string
  default     = "us-west-2"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "my-eks-cluster"
}

variable "node_instance_type" {
  description = "The EC2 instance type for the EKS worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "desired_capacity" {
  description = "The desired number of worker nodes in the EKS cluster"
  type        = number
  default     = 3
}

variable "max_capacity" {
  description = "The maximum number of worker nodes in the EKS cluster"
  type        = number
  default     = 5
}

variable "min_capacity" {
  description = "The minimum number of worker nodes in the EKS cluster"
  type        = number
  default     = 1
}
