# Amazon VPC CNI.
# Provides native AWS VPC networking for Kubernetes Pods.
resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "vpc-cni"

  tags = {
    Name = "${var.project_name}-vpc-cni"
  }
}

# CoreDNS.
# Provides DNS resolution inside the Kubernetes cluster.
resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "coredns"

  depends_on = [
    aws_eks_node_group.main
  ]

  tags = {
    Name = "${var.project_name}-coredns"
  }
}

# kube-proxy.
# Handles Kubernetes Service networking on the worker nodes.
resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "kube-proxy"

  tags = {
    Name = "${var.project_name}-kube-proxy"
  }
}
