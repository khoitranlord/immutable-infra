terraform {
  required_version = ">= 0.12.24"
  backend "s3" {
    bucket = "packer-demo"
    key = "infra/container-based/terraform.tfstate"
    region = "us-east-1"
  }
}
