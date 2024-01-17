resource "aws_instance" "my_instance" {
  count = length(var.instance_names)


  ami                    = "ami-05fb0b8c1424f266b" # Specify the AMI ID for your desired Amazon Machine Image
  instance_type          = "t2.large"
  key_name               = "admin-ajay" # Change this to your key pair name
  vpc_security_group_ids = [aws_security_group.terraform-instance-sg.id]
  // iam_instance_profile = iam_instance_profile.my-profile.name

  iam_instance_profile = aws_iam_instance_profile.example_profile.name
  //for storage
  root_block_device {
    volume_size = 30
  }

  tags = {
    Name = var.instance_names[count.index]
  }


}

output "jenkins_public_ip" {
  value = [for instance in aws_instance.my_instance : instance.public_ip]

}
/*
resource "iam_instance_profile" "my-profile" {
  role= iam_role.example.name
  name="My profile"
  
}
*/



#Create security group 
resource "aws_security_group" "terraform-instance-sg" {
  name        = "terraform-created-sg"
  description = "Allow inbound ports 22, 8080"
  vpc_id      = "vpc-0a35a83de5d6649ab"

  ingress = [
    for port in [22, 80, 443, 8080] : {
      description      = "inbound rules"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  #Allow all outbound requests
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
