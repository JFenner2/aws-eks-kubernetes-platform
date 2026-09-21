resource "kubernetes_namespace_v1" "project5" {
  metadata {
    name = "project5"

    labels = {
      "app.kubernetes.io/part-of"    = "project5"
      "app.kubernetes.io/managed-by" = "Terraform"
    }
  }

  depends_on = [
    aws_eks_node_group.main
  ]
}

resource "kubernetes_role_v1" "github_deployer" {
  metadata {
    name      = "github-deployer"
    namespace = kubernetes_namespace_v1.project5.metadata[0].name
  }

  rule {
    api_groups = [""]
    resources  = ["configmaps", "secrets", "services", "serviceaccounts"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }

  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["apps"]
    resources  = ["deployments", "replicasets"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }

  rule {
    api_groups = ["autoscaling"]
    resources  = ["horizontalpodautoscalers"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }

  rule {
    api_groups = ["policy"]
    resources  = ["poddisruptionbudgets"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }

  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }
}

resource "kubernetes_role_binding_v1" "github_deployer" {
  metadata {
    name      = "github-deployer"
    namespace = kubernetes_namespace_v1.project5.metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.github_deployer.metadata[0].name
  }

  subject {
    kind      = "Group"
    name      = "project5-deployers"
    api_group = "rbac.authorization.k8s.io"
  }

  lifecycle {
    ignore_changes = [
      subject[0].namespace
    ]
  }
}
