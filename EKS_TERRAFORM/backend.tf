terraform {
  backend "s3" {
    bucket = "ajay-project017" # Replace with your actual S3 bucket name
    key    = "EKS/terraform.tfstate"
    region = "ca-central-1"
  }
}
