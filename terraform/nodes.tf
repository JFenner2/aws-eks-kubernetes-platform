# EKS managed node group.

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.project_name}-nodes"
  node_role_arn   = aws_iam_role.eks_nodes.arn

  # Worker nodes live only in our private subnets.
  subnet_ids = aws_subnet.private[*].id

  # Small general-purpose instances are sufficient for this portfolio project.
  instance_types = ["t3.medium"]

  capacity_type = "ON_DEMAND"

  scaling_config {
    desired_size = 2
    min_size     = 2
    max_size     = 3
  }

  update_config {
    max_unavailable = 1
  }

  # The VPC CNI Pod Identity association must exist before workers launch.
  # This ensures aws-node can obtain its dedicated AWS permissions during
  # initial node bootstrap instead of requiring CNI permissions on the
  # EC2 worker-node role.
  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_ecr_read_only,
    aws_eks_pod_identity_association.vpc_cni
  ]

  tags = {
    Name = "${var.project_name}-nodes"
  }
}
