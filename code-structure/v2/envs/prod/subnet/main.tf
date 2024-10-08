provider "aws" {
  region = var.region
}

module "subnet" {
  source = "../../../modules/subnet"

  environment = var.environment
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  cidr_block  = var.cidr_block
}
