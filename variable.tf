variable "region" {
  description = "The region in which the resources will be created."
  default     = "eu-west-1"
}

variable "domain_name" {
  description = "The domain name for the application."
  default     = "hotstoremag.com"
}

variable "database_name" {
  description = "The name of the database."
  default     = "store_mag"
}

variable "api_gateway_ecr_name" {
  description = "The name of the ECR repository for the API Gateway."
  default     = "store-mag-api-gateway"
}

variable "employee_service_ecr_name" {
  description = "The name of the ECR repository for the Employee Service."
  default     = "store-mag-employee-service"
}

variable "store_service_ecr_name" {
  description = "The name of the ECR repository for the Store Service."
  default     = "store-mag-store-service"
}

variable "schedule_service_ecr_name" {
  description = "The name of the ECR repository for the Schedule Service."
  default     = "store-mag-schedule-service"
}
