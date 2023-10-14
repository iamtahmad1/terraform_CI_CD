variable "ami_id" {
  description = "The ID of the Amazon Machine Image (AMI)."
}

variable "instance_type" {
  description = "The EC2 instance type."
}

variable "tags" {
  description = "A map of tags for the AWS instance."
  type        = map(string)
}
