ami_id        = "ami-067c21fb1979f0b27"  # Replace with your desired AMI ID
instance_type = "t2.micro"              # Replace with your desired instance type

tags = {
  Name        = "qa Instance"
  Environment = "qa"
  // Add any other tags as needed
}
