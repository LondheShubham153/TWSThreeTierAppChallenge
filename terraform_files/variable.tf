variable "instance_names" {
  description = "List of names for instances"
  type        = list(string)
  #default     = ["ansible", "node1", "node2"]
  default = ["Jenkins Server"]
}
