resource "aws_eks_cluster" "finance_app" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster]
}

resource "aws_eks_node_group" "finance_app" {
  cluster_name    = aws_eks_cluster.finance_app.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks_node.arn

  scaling_config {
    desired_size = var.node_desired_size
    max_size     = var.node_max_size
    min_size     = var.node_min_size
  }

  remote_access {
    ec2_ssh_key = var.ssh_key_name
    source_security_group_id = var.security_group_id
  }

  depends_on = [aws_iam_role_policy_attachment.eks_node]
}

resource "aws_iam_role" "eks_cluster" {
  name = "finance-app-eks-cluster"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role" "eks_node" {
  name = "finance-app-eks-node"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_node" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node.name
}

resource "aws_iam_instance_profile" "eks_node" {
  name = "finance-app-eks-node"

  role = aws_iam_role.eks_node.name
}

output "kubeconfig" {
  value = aws_eks_cluster.finance_app.kubeconfig
}

output "config_map_aws_auth" {
  value = aws_eks_cluster.finance_app.config_map_aws_auth
}
