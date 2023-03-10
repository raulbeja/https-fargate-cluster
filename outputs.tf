output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "region" {
  value = var.aws_region
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.vpc.cidr_block
}

output "public_subnets" {
   value = [
      for subnet in aws_subnet.pub_subnet : subnet.id
  ]
}

output "private_subnets" {
   value = [
      for subnet in aws_subnet.priv_subnet : subnet.id
  ]
}

output "ecs_alb_listener_arn" {
  value = aws_alb_listener.ecs_alb_https_listener.arn
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs_fargate_cluster.name
}

output "ecs_service_name" {
  value = aws_ecs_service.ecs_service.name
}

output "ecs_cluster_role_name" {
  value = aws_iam_role.fargate_iam_role.name
}

output "ecs_cluster_role_arn" {
  value = aws_iam_role.fargate_iam_role.arn
}

output "ecs_domain_name" {
  value = var.ecs_domain_name
}

output "docker_image" {
  value = var.docker_image
}
output "ecs_endpoint" {
  value = "https://${var.ecs_cluster_name}.${var.ecs_domain_name}"
}