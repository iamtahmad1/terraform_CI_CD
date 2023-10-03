# main.tf
provider "aws" {
  region = "ap-south-1" # Replace with your desired AWS region
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0" # Replace with your desired AMI ID
  instance_type = "t2.micro"             # Replace with your desired instance type
   tags = {
    Name = "MyEC2Instance"
    Environment = "Development"
    Project = "TerraformDemo"
  }
}