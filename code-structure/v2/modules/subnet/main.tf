resource "aws_subnet" "spixrnc-subnet" {
  vpc_id     = var.vpc_id
  cidr_block = var.cidr_block

  tags = {
    Name = "spixrnc-${var.environment}-subnet"
  }
}
