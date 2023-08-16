module "network" {
  source = "../../modules/network"

  env  = var.env
  name = var.name

  vpc_cidr = var.vpc_cidr
  vpc_id   = module.network.vpc_id
  subnets  = var.subnets
}

module "fargate" {
  source = "../../modules/fargate"

  env = var.env
  name = var.name

  vpc_id = module.network.vpc_id
  public_subnets  = module.network.public_subnets

  capacity_provider = var.capacity_provider
  ecs_task = var.ecs_task
  desired_count = var.desired_count
  fargate_weight = var.fargate_weight
}