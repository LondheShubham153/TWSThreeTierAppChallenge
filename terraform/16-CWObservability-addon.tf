# resource "aws_eks_addon" "cloudwatch_observability" {
#   cluster_name             = aws_eks_cluster.demo.name
#   addon_name               = "amazon-cloudwatch-observability"
#   addon_version            = "v1.2.0-eksbuild.1"
#   service_account_role_arn = aws_iam_role.eks_cloudwatch_observability.arn
# }