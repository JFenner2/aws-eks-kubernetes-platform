# IAM policy required by the AWS Load Balancer Controller.
resource "aws_iam_policy" "load_balancer_controller" {
  name        = "${var.project_name}-aws-load-balancer-controller"
  description = "IAM permissions for the AWS Load Balancer Controller"

  policy = file("${path.module}/../iam_policy.json")

  tags = {
    Name = "${var.project_name}-aws-load-balancer-controller"
  }
}

# IAM role assumed by the AWS Load Balancer Controller through EKS Pod Identity.
resource "aws_iam_role" "load_balancer_controller" {
  name = "${var.project_name}-aws-load-balancer-controller"

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
    Name = "${var.project_name}-aws-load-balancer-controller"
  }
}

# Attach the controller permissions to its dedicated IAM role.
resource "aws_iam_role_policy_attachment" "load_balancer_controller" {
  role       = aws_iam_role.load_balancer_controller.name
  policy_arn = aws_iam_policy.load_balancer_controller.arn
}

# Associate the Kubernetes ServiceAccount with the IAM role.
resource "aws_eks_pod_identity_association" "load_balancer_controller" {
  cluster_name    = aws_eks_cluster.main.name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
  role_arn        = aws_iam_role.load_balancer_controller.arn

  depends_on = [
    aws_eks_addon.pod_identity_agent,
    aws_iam_role_policy_attachment.load_balancer_controller
  ]
}
