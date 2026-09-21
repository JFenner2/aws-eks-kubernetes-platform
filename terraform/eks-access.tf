# Allow the GitHub Actions IAM role to authenticate to the EKS cluster.
#
# AWS IAM handles authentication into EKS.
# Kubernetes RBAC separately controls what this identity can do.
resource "aws_eks_access_entry" "github_actions" {
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = aws_iam_role.github_actions.arn

  kubernetes_groups = [
    "project5-deployers"
  ]

  type = "STANDARD"

  depends_on = [
    aws_eks_cluster.main
  ]

  tags = {
    Name = "${var.project_name}-github-actions"
  }
}
