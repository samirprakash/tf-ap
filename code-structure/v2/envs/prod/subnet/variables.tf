variable "region" {
  type    = string
  default = "us-west-2"
}

variable "cidr_block" {
  type    = string
  default = "10.0.0.0/19"
}

variable "environment" {
  type    = string
  default = "prod"
}
