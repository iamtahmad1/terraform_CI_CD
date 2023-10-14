#main.tf
provider "aws" {
  region = "ap-south-1" # Replace with your desired AWS region
}

resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags          = var.tags
}
