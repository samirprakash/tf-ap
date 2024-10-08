resource "aws_vpc" "spixrnc-vpc" {
  cidr_block = var.cidr_block

  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name = "spixrnc-${var.environment}-vpc"
  }
}
