variable "vpc_cidr" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "cidr_public_subnet" {
  type = list(string)
}

variable "cidr_private_subnet" {
  type = list(string)
}

variable "us_availability_zone" {
  type = list(string)
}

variable "ec2_aim" {
  type = string
}
variable "ssh_public_key" {
  type = string
}