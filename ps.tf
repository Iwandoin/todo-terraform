resource "aws_ssm_parameter" "DATABASE" {
  name  = "/todo/backend/DATABASE"
  type  = "SecureString"
  value = "postgres"
  overwrite = true
}

resource "aws_ssm_parameter" "DEBUG" {
  name  = "/todo/backend/DEBUG"
  type  = "SecureString"
  value = "0"
  overwrite = true
}

resource "aws_ssm_parameter" "DJANGO_ALLOWED_HOSTS" {
  name  = "/todo/backend/DJANGO_ALLOWED_HOSTS"
  type  = "SecureString"
  value = "*"
  overwrite = true
}

resource "aws_ssm_parameter" "SECRET_KEY" {
  name  = "/todo/backend/SECRET_KEY"
  type  = "SecureString"
  value = "kx8hi*n!9@^7m2z5hi!0pdw%3q=h@sn0el^i+g4u59=*g_uw$e"
  overwrite = true
}

resource "aws_ssm_parameter" "SQL_DATABASE" {
  name  = "/todo/backend/SQL_DATABASE"
  type  = "SecureString"
  value = "backend"
  overwrite = true
}

resource "aws_ssm_parameter" "SQL_ENGINE" {
  name  = "/todo/backend/SQL_ENGINE"
  type  = "SecureString"
  value = "django.db.backends.postgresql"
  overwrite = true
}

resource "aws_ssm_parameter" "SQL_HOST" {
  name  = "/todo/backend/SQL_HOST"
  type  = "SecureString"
  value = aws_db_instance.rds-instance.address
  overwrite = true
}

resource "aws_ssm_parameter" "SQL_PASSWORD" {
  name  = "/todo/backend/SQL_PASSWORD"
  type  = "SecureString"
  value = random_password.password_db.result
  overwrite = true
}

resource "aws_ssm_parameter" "SQL_PORT" {
  name  = "/todo/backend/SQL_PORT"
  type  = "SecureString"
  value = "5432"
  overwrite = true
}

resource "aws_ssm_parameter" "SQL_USER" {
  name  = "/todo/backend/SQL_USER"
  type  = "SecureString"
  value = "backend"
  overwrite = true
}

resource "aws_ssm_parameter" "AWS_S3_CUSTOM_DOMAIN" {
  name  = "/todo/backend/AWS_S3_CUSTOM_DOMAIN"
  type  = "SecureString"
  value = aws_cloudfront_distribution.s3.domain_name
  overwrite = true
}
