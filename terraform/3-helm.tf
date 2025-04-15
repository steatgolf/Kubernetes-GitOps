resource "helm_release" "external_nginx" {
  name             = "external-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "webapp"
  version          = "4.12.1"
  create_namespace = true
  depends_on = [ aws_eks_node_group.general ]
}

# helm install argocd -n argocd --create-namespace argo/argo-cd --version 3.35.4 -f terraform/values/argocd.yaml
resource "helm_release" "argocd" {
  name = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "3.35.4"
  values = [file("values/argocd.yaml")]
  depends_on = [ helm_release.external_nginx ]
}