variable "region" {}

variable "key_name" {
  description = "Name of the SSH keypair to use in AWS."
}
variable "amis" {}

variable "vpc-cidr" {}

variable "subnet-cidr-a" {}

variable "subnet-cidr-b" {}

variable "subnet-cidr-c" {}
