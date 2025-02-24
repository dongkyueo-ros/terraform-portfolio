output "cluster_endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}

output "cluster_name" {
  value = aws_eks_cluster.cluster.name
}

output "cluster_id" {
  value = aws_eks_cluster.cluster.cluster_id
}

output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.cluster.certificate_authority[0].data
}

output "cluster_oidc_issuer_url" {
  value = aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}

output "oidc_provider_arn" {
  description = "ARN of the created OIDC provider"
  value       = aws_iam_openid_connect_provider.oidc_provider[0].arn
}

output "cluster_workernode_release" {
  value = values(aws_eks_node_group.worker)[0].node_group_name
}

output "eks_nodes_private_dns" {
  value = flatten([
    for instance_id in data.aws_instances.eks_nodes.ids :
    data.aws_instances.eks_nodes[instance_id].private_dns
  ])
}