resource "aws_ecr_repository" "store_mag_api_gateway" {
  name                 = var.api_gateway_ecr_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "store_mag_employee_service" {
  name                 = var.employee_service_ecr_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "store_mag_store_service" {
  name                 = var.store_service_ecr_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "store_mag_schedule_service" {
  name                 = var.schedule_service_ecr_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
