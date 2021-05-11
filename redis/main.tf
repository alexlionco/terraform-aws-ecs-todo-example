resource "aws_security_group" "aec_sg" {
  vpc_id = var.vpc_id


  ingress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port        = 6379
    protocol         = "tcp"
    to_port          = 6379
    security_groups  = []
    prefix_list_ids  = []
    description      = "REDIS"
    self             = true
  }]

  egress = [{
    from_port        = 0
    protocol         = "tcp"
    to_port          = 65535
    ipv6_cidr_blocks = ["::/0"]
    cidr_blocks      = ["0.0.0.0/0"]
    prefix_list_ids  = []
    description      = "ALL TCP"
    security_groups  = []
    self             = true
  }]
}

resource "aws_elasticache_subnet_group" "aec_subnet_grp" {
  name       = "redis-subnet-grp-todoapp"
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_replication_group" "redis_rg" {
  replication_group_description = "redis rg"
  replication_group_id = "redis-rg"
  engine                = "redis"
  node_type             = "cache.t3.micro"
  parameter_group_name  = "default.redis6.x"
  engine_version        = "6.x"
  port                  = 6379
  security_group_ids = ["${aws_security_group.aec_sg.id}"]
  subnet_group_name = "${aws_elasticache_subnet_group.aec_subnet_grp.id}"

  cluster_mode {
    replicas_per_node_group = 1
    num_node_groups         = 1
  }
}