variable "key_name" {
  description = "Name of the SSH keypair to use in AWS."
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

# ubuntu-trusty-16.04 (x64)
variable "aws_amis" {
  default = {
    "us-east-1" = "ami-759bc50a"

  }
}
