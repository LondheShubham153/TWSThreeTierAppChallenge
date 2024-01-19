variable "instance_names" {
  description = "List of names for instances"
  type        = list(string)
  #default     = ["ansible", "node1", "node2"]
  default = ["Jenkins Server"]
 
}



variable "vpc_id" {
  description = "List of names for instances"
  type        = string
  default = "vpc-0c98b9c4f24d671ee"
}

variable "ami_id" {
  description = "List of names for instances"
  type        = string
  default = "ami-0a2e7efb4257c0907"
}


variable "instance_type" {
  description = "List of names for instances"
  type        = string
  default =  "t2.large"
}

