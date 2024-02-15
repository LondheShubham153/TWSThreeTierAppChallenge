# data "aws_iam_policy_document" "eks_cluster_cloudwatch_assume_role_policy" {
#   statement {
#     actions = ["sts:AssumeRoleWithWebIdentity"]
#     effect  = "Allow"

#     condition {
#       test     = "StringEquals"
#       variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
#       values   = ["system:serviceaccount:amazon-cloudwatch:cloudwatch-agent"]
#     }

#     principals {
#       identifiers = [aws_iam_openid_connect_provider.eks.arn]
#       type        = "Federated"
#     }
#   }
# }

# resource "aws_iam_role" "eks_cloudwatch_observability" {
#   assume_role_policy = data.aws_iam_policy_document.eks_cluster_cloudwatch_assume_role_policy.json
#   name               = "eks-cloudwatch-observability"
# }

# resource "aws_iam_role_policy_attachment" "amazon_cloudwatch_agent_server_policy" {
#   role       = aws_iam_role.eks_cloudwatch_observability.name
#   policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
# }

# resource "aws_iam_role_policy_attachment" "amazon_Xray_policy" {
#   role       = aws_iam_role.eks_cloudwatch_observability.name
#   policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
# }