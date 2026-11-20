data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 2)
  tags = {
    Project   = var.project_name
    ManagedBy = "Terraform"
  }
}

module "network" {
  source               = "./modules/network"
  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  availability_zones   = local.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  tags                 = local.tags
}

module "application" {
  source         = "./modules/application"
  project_name   = var.project_name
  vpc_id         = module.network.vpc_id
  vpc_cidr       = var.vpc_cidr
  public_subnets = module.network.public_subnet_ids
  private_subnets = module.network.private_subnet_ids
  frontend_image = var.frontend_image
  backend_image  = var.backend_image
  desired_count  = var.desired_count
  tags           = local.tags
}
