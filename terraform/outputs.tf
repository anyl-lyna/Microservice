output "eks_cluster_name" {
  value = module.eks_cluster.cluster_name
}

output "rds_endpoint" {
  value = aws_db_instance.example.endpoint
}