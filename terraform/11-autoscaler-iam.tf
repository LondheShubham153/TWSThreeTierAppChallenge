data "aws_iam_policy_document" "autoscaling_policy" {
  statement {
    actions = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeTags",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "ec2:DescribeLaunchTemplateVersions",
        ]
        resources = ["*"]
        effect  = "Allow"
    }
  }

resource "aws_iam_policy" "autoscaling_policy" {
  name        = "AmazonEKSAutoscalerPolicy"
  description = "IAM policy for autoscaling"

  policy = data.aws_iam_policy_document.autoscaling_policy.json
}

resource "aws_iam_role" "autoscaling_role" {
  name = "AmazonEKSClusterAutoscalerRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          # Service = "autoscaling.amazonaws.com",
          Federated = aws_iam_openid_connect_provider.eks.arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub" = "system:serviceaccount:kube-system:cluster-autoscaler"
          }
        }
      },
    ]
  })
}
resource "aws_iam_role_policy_attachment" "amazon_eks_autoscaler" {
  role       = aws_iam_role.autoscaling_role.name
  policy_arn = aws_iam_policy.autoscaling_policy.arn
}
output "autoscaler_role_arn" {
  value = aws_iam_role.autoscaling_role.arn
}