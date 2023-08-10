module "network" {
  source = "../../modules/network"

  env  = var.env
  name = var.name

  vpc_id   = module.network.vpc_id
  vpc_cidr = var.vpc_cidr
  subnets  = var.subnets
}