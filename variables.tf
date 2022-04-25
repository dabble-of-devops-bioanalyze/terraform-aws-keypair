##################################################
# Variables
# This file has various groupings of variables
##################################################

##################################################
# AWS
##################################################

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Region"
}

variable "private_key_file" {
  type    = string
  default = "files/user-data/key-pair/id_rsa"
}

variable "public_key_file" {
  type    = string
  default = "files/user-data/key-pair/id_rsa.pub"
}
