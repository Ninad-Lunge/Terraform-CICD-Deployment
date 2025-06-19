provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source         = "./modules/vpc"
  vpc_cidr       = var.vpc_cidr
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  project_name   = var.project_name
}

module "iam" {
  source       = "./modules/iam"
  project_name = var.project_name
}

module "ecr" {
  source       = "./modules/ecr"
  project_name = var.project_name
}

module "alb" {
  source            = "./modules/alb"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  project_name      = var.project_name
}

module "ecs" {
  source             = "./modules/ecs"
  project_name       = var.project_name
  private_subnet_ids = module.vpc.private_subnet_ids
  vpc_id             = module.vpc.vpc_id
  alb_target_group_arn = module.alb.target_group_arn
  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  ecs_task_role_arn = module.iam.ecs_task_role_arn
  ecr_repository_url = module.ecr.repository_url
  container_port     = var.container_port
}

module "codepipeline" {
  source                = "./modules/codepipeline"
  project_name          = var.project_name
  github_owner          = var.github_owner
  github_repo           = var.github_repo
  github_branch         = var.github_branch
  github_token          = var.github_token
  ecr_repository_url    = module.ecr.repository_url
  ecs_cluster_name      = module.ecs.cluster_name
  ecs_service_name      = module.ecs.service_name
  codepipeline_role_arn = module.iam.codepipeline_role_arn
  codebuild_role_arn    = module.iam.codebuild_role_arn
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
}
