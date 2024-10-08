variable "region" {
  default = "us-west-2"
}

variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "environment" {
  default = "dev"
}

variable "enable_dns_support" {
  default = true
}

variable "enable_dns_hostnames" {
  default = true
}
