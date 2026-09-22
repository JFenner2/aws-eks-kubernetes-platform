# Amazon EKS cluster.

resource "aws_eks_cluster" "main" {
  name     = "${var.project_name}-cluster"
  role_arn = aws_iam_role.eks_cluster.arn

  # Use the modern EKS access management API.
  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }

  vpc_config {
    # EKS creates networking interfaces in these subnets
    # so the control plane can communicate with the VPC.
    subnet_ids = aws_subnet.private[*].id

    # Enable private API access for communication from within the VPC.
    endpoint_private_access = true

    # Public API access is required by the current CI/CD architecture because
    # GitHub-hosted Actions runners deploy to EKS using kubectl and Helm.
    #
    # GitHub-hosted runners do not provide a small fixed set of outbound IPs
    # suitable for an EKS API allowlist, so public access remains reachable
    # from the internet. Authentication is enforced through AWS IAM/EKS access
    # entries, with Kubernetes RBAC restricting the GitHub deployer to the
    # project5 namespace.
    #
    # A stricter production architecture would use a private EKS endpoint with
    # a deployment runner located inside the VPC or connected private network.
    endpoint_public_access = true
    public_access_cidrs    = ["0.0.0.0/0"]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]

  tags = {
    Name = "${var.project_name}-cluster"
  }
}
