output "redis_endpoint" {
  value = aws_elasticache_replication_group.redis_rg.primary_endpoint_address
}