module "network" {
  source = "./network"
}

module "postgres" {
  source = "./postgres"

  db_password = var.db_password
  db_username = var.db_username
  vpc_id = module.network.vpc_id
  subnet_ids = module.network.subnet_ids
}

module "redis" {
  source = "./redis"

  vpc_id = module.network.vpc_id
  subnet_ids = module.network.subnet_ids
}

module "app" {
  source = "./app"

  db_password = var.db_password
  db_username = var.db_username
  subnet_ids = module.network.subnet_ids
  vpc_id = module.network.vpc_id
  redis_endpoint = module.redis.redis_endpoint
  pg_endpoint = module.postgres.pg_endpoint
}