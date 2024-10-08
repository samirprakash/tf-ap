resource "aws_vpc" "spixrnc-vpc" {
  cidr_block = var.cidr_block

  enable_dns_support   = false
  enable_dns_hostnames = false

  tags = {
    Name = "spixrnc-${var.environment}-vpc"
  }
}
