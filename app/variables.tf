variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "redis_endpoint" {
  type = string
}

variable "pg_endpoint" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_username" {
  type      = string
  sensitive = true
}