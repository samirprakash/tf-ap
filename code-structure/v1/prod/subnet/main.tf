resource "aws_subnet" "spixrnc-subnet" {
  vpc_id     = data.terraform_remote_state.vpc.outputs.vpc_id
  cidr_block = var.cidr_block

  tags = {
    Name = "spixrnc-${var.environment}-subnet"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "../vpc/terraform.tfstate"
  }
}
