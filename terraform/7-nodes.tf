resource "aws_iam_role" "nodes" {
  name = "eks-node-group-nodes"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "nodes_amazon_eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes_amazon_eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes_amazon_ec2_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes.name
}

# resource "aws_iam_role_policy_attachment" "nodes_amazon_cloudwatch_agent_server_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
#   role       = aws_iam_role.nodes.name
# }

# resource "aws_launch_configuration" "eks_nodes_launch_config" {
#   name = "eks-nodes-launch-config"
  
#   image_id = "ami-06aa3f7caf3a30282"  # Specify your desired AMI ID
#   instance_type = "t3.medium"        # Specify your desired instance type

#   user_data = <<-EOF
#               #!/bin/bash
#               echo '/c/Users/pc/.ssh/id_rsa.pub' >> /home/ubuntu/.ssh/authorized_keys
#               EOF
# }


resource "aws_eks_node_group" "private_nodes" {
  cluster_name    = aws_eks_cluster.demo.name
  node_group_name = "private-nodes"
  node_role_arn   = aws_iam_role.nodes.arn

  
  subnet_ids = [
    aws_subnet.private_us_east_1a.id,
    aws_subnet.private_us_east_1b.id
  ]

  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.medium"]

  scaling_config {
    desired_size = 1
    max_size     = 5
    min_size     = 0
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "general"
  }

  depends_on = [
    aws_iam_role_policy_attachment.nodes_amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.nodes_amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.nodes_amazon_ec2_container_registry_read_only,
  ]
}