# Dedicated IAM role for the Amazon VPC CNI.
#
# The aws-node pods use EKS Pod Identity to obtain temporary
# AWS credentials instead of inheriting CNI permissions from
# the EC2 worker node IAM role.

resource "aws_iam_role" "vpc_cni" {
  name = "${var.project_name}-vpc-cni"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "pods.eks.amazonaws.com"
        }

        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-vpc-cni"
  }
}

# Give the dedicated VPC CNI role the AWS permissions required
# to manage pod networking interfaces and IP addresses.

resource "aws_iam_role_policy_attachment" "vpc_cni" {
  role       = aws_iam_role.vpc_cni.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# Associate the aws-node Kubernetes ServiceAccount with the
# dedicated IAM role through EKS Pod Identity.

resource "aws_eks_pod_identity_association" "vpc_cni" {
  cluster_name    = aws_eks_cluster.main.name
  namespace       = "kube-system"
  service_account = "aws-node"
  role_arn        = aws_iam_role.vpc_cni.arn

  depends_on = [
    aws_eks_addon.pod_identity_agent,
    aws_eks_addon.vpc_cni,
    aws_iam_role_policy_attachment.vpc_cni
  ]
}
