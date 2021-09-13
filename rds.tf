resource "aws_db_instance" "rds-instance" {
  depends_on             = [aws_security_group.Database]
  identifier             = "todot"
  allocated_storage      = "20"
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "12.7"
  instance_class         = "db.t2.micro"
  name                   = "backend"
  username               = "backend"
  password               = random_password.password_db.result
  vpc_security_group_ids = [aws_security_group.Database.id]
  db_subnet_group_name   = aws_db_subnet_group.default.id
  publicly_accessible    = "true"
  port                   = 5432
  backup_retention_period = 0
  skip_final_snapshot = "true"
}

resource "random_password" "password_db" {
  length           = 16
  special          = false
}

resource "aws_db_subnet_group" "default" {
  name        = "db_sub_gr"
  description = "Db group of subnets"
  subnet_ids = aws_subnet.PublicAZ.*.id
  lifecycle {
    create_before_destroy = true
  }
}
output "db_url" {
  value = "${aws_db_instance.rds-instance.address}"
}