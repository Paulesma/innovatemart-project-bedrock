output "cluster_endpoint" {
  description = "The endpoint URL for your Amazon EKS cluster API server."
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_name" {
  description = "The precise naming convention string for the EKS cluster."
  value       = aws_eks_cluster.main.name
}

output "region" {
  description = "The target deployment AWS Region constraint."
  value       = "us-east-1"
}

output "vpc_id" {
  description = "The unique tracking ID assigned to the primary project VPC."
  value       = aws_vpc.main.id
}

output "assets_bucket_name" {
  description = "The globally unique identifier for the serverless asset storage bucket."
  value       = aws_s3_bucket.assets.id
}

# -----------------------------------------------------------------------------
# Optional Helper Outputs (Useful for your application deployment phase)
# -----------------------------------------------------------------------------
output "mysql_endpoint" {
  description = "The private connection endpoint for the managed RDS MySQL database."
  value       = aws_db_instance.mysql.endpoint
}

output "postgres_endpoint" {
  description = "The private connection endpoint for the managed RDS PostgreSQL database."
  value       = aws_db_instance.postgres.endpoint
}
