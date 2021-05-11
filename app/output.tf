output "ecr_repository_endpoint" {
  value = aws_ecr_repository.ecr_repo.repository_url
}