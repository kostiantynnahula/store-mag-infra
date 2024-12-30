resource "aws_secretsmanager_secret" "store_mag_rds_secret_credentials" {
  name                    = "store_mag_rds_secret_credentials_v10"
  description             = "Store mag secret credentials"
  recovery_window_in_days = 7
}

resource "random_password" "store_mag_password" {
  length           = 20
  special          = false
  override_special = "_%@"
}

resource "aws_secretsmanager_secret_version" "db_store_mag_credentials_version" {
  secret_id = aws_secretsmanager_secret.store_mag_rds_secret_credentials.id
  secret_string = jsonencode({
    username = "postgres",
    password = random_password.store_mag_password.result
  })
}

resource "aws_security_group" "allow_db" {
  name        = "allow_db"
  description = "Allow DB"

  ingress {
    from_port        = 5430
    to_port          = 5440
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_db_instance" "store_mag_db" {
  allocated_storage      = 20
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  engine                 = "postgres"
  identifier             = "dev-store-mag-db"
  engine_version         = "13"
  instance_class         = "db.t3.micro"
  db_name                = var.database_name
  username               = jsondecode(aws_secretsmanager_secret_version.db_store_mag_credentials_version.secret_string).username
  password               = jsondecode(aws_secretsmanager_secret_version.db_store_mag_credentials_version.secret_string).password
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.allow_db.id]
}


resource "aws_iam_role" "rds_store_mag_access_role" {
  name = "rds_store_mag_access_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow",
        Principal = {
          Service = "rds.amazonaws.com"
        },
      }
    ]
  })
}

resource "aws_iam_policy" "rds_store_mag_secret_policy" {
  name = "rds_store_mag_secret_policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        Resource = aws_secretsmanager_secret.store_mag_rds_secret_credentials.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rds_store_mag_secret_policy_attachment" {
  role       = aws_iam_role.rds_store_mag_access_role.name
  policy_arn = aws_iam_policy.rds_store_mag_secret_policy.arn
}
