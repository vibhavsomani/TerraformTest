variable "ami" {
  default = "ami-0b898040803850657"
}

variable "instance_type" {
  default = "t2.nano"
}

variable "resource-name" {
  default = ""
}

variable "environment" {
  default = ""
}

variable "region" {
  default = "us-east-1"
}

variable "Creation-Time" {
  default = ""
}

variable "public_subnets_cidr" {
	default = ""
}

variable "private_subnets_cidr" {
	default = ""
}

variable "availability_zone" {
  default = ""
}

variable "ec2_name" {
  default = ""
}

variable "key_name" {
  default = "Test"
}

variable "associate_public_ip_address" {
  default = "false"
}

