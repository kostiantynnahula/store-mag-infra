### RDS
output "rds_db_address" {
  value = aws_db_instance.store_mag_db.address
}

output "rds_db_port" {
  value = aws_db_instance.store_mag_db.port
}

output "rds_db_name" {
  value = aws_db_instance.store_mag_db.db_name
}

output "rds_cidr_block" {
  value       = aws_default_vpc.default_vpc.cidr_block
  description = "The CIDR block allowed to connect to the RDS instance."
}

### ECS
output "cluster_id" {
  value = aws_ecs_cluster.main.id
}

output "ecs_service_sg_id" {
  value = aws_security_group.ecs_service_sg.id
}

### VPC
output "default_vpc_id" {
  value = aws_default_vpc.default_vpc.id
}

output "default_subnet_a_id" {
  value = aws_default_subnet.default_subnet_a.id
}

output "default_subnet_b_id" {
  value = aws_default_subnet.default_subnet_b.id
}

output "db_subnet_group_id" {
  value = aws_db_subnet_group.db_subnet_group.id
}

### IAM 
output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecsTaskExecutionRole.arn
}

### ALB
output "app_url" {
  value = aws_alb.application_load_balancer.dns_name
}

output "alb_arn" {
  value = aws_alb.application_load_balancer.arn
}

output "alb_sg_id" {
  value = aws_security_group.load_balancer_security_group.id
}

output "alb_listener_arn" {
  value = aws_lb_listener.alb_listener.arn
}

output "api_gateway_tg_arn" {
  value = aws_lb_target_group.api_gateway_tg.arn
}

output "store_service_dns_namespace" {
  value = aws_service_discovery_private_dns_namespace.store_mag_service_namespace.id
}

# output "store_mag_cert_arn" {
#   value = aws_acm_certificate_validation.store_mag_cert_validation.certificate_arn
# }

### ECR Repositories
output "ecr_api_gateway_repository" {
  value = aws_ecr_repository.store_mag_api_gateway.repository_url
}

output "ecr_store_service_repository" {
  value = aws_ecr_repository.store_mag_store_service.repository_url
}

output "ecr_employee_service_repository" {
  value = aws_ecr_repository.store_mag_employee_service.repository_url
}

output "ecr_schedule_service_repository" {
  value = aws_ecr_repository.store_mag_schedule_service.repository_url
}

