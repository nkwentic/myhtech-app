output "kubeconfig" {
  value = module.eks.kubeconfig
}

output "config_map_aws_auth" {
  value = module.eks.config_map_aws_auth
}

output "worker_iam_role_arn" {
  value = module.eks.worker_iam_role_arn
}

output "worker_security_group_id" {
  value = module.eks.worker_security_group_id
}
