resource "aws_default_vpc" "default_vpc" {}

resource "aws_default_subnet" "default_subnet_a" {
  availability_zone = "eu-west-1a"
}

resource "aws_default_subnet" "default_subnet_b" {
  availability_zone = "eu-west-1b"
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name = "db_subnet_group_store_mag_lambda"
  subnet_ids = [
    aws_default_subnet.default_subnet_a.id,
    aws_default_subnet.default_subnet_b.id
  ]
}

resource "aws_alb" "application_load_balancer" {
  name               = "store-mag-alb"
  load_balancer_type = "application"
  subnets = [
    aws_default_subnet.default_subnet_a.id,
    aws_default_subnet.default_subnet_b.id
  ]
  security_groups = [aws_security_group.load_balancer_security_group.id]
}

resource "aws_security_group" "load_balancer_security_group" {
  name        = "store-mag-alb-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_default_vpc.default_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic in from all sources
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.application_load_balancer.arn #  load balancer
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found Test"
      status_code  = "404"
    }
  }
}

resource "aws_security_group" "ecs_service_sg" {
  name        = "ecs-service-sg"
  description = "Allow traffic from ALB"
  vpc_id      = aws_default_vpc.default_vpc.id

  ingress {
    from_port       = 3000
    to_port         = 4010
    protocol        = "tcp"
    security_groups = [aws_security_group.load_balancer_security_group.id]
  }

  # Allow traffic between services in the same security group
  ingress {
    from_port = 3000
    to_port   = 3001
    protocol  = "tcp"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

