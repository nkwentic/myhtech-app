# Configure the AWS provider
provider "aws" {
  region = var.aws_region
}

# Configure the EKS provider
provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = var.tags
}

module "eks_cluster" {
  source = "terraform-aws-modules/eks/aws"
  version = "~> 12.0"

  cluster_name = var.cluster_name
  subnets      = module.vpc.private_subnets
  vpc_id       = module.vpc.vpc_id

  tags = var.tags
}

resource "aws_security_group_rule" "eks_cluster_ingress_https" {
  security_group_id = module.eks_cluster.eks_cluster_security_group_id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

output "kubeconfig" {
  value = module.eks_cluster.kubeconfig
}
