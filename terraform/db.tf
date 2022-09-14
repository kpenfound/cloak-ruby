resource "random_password" "db" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_db_instance" "blog" {
  engine                 = "postgres"
  instance_class         = var.db_class
  allocated_storage      = 20
  engine_version         = "14.4"
  db_name                = var.name
  username               = var.name
  password               = random_password.db.result
  skip_final_snapshot    = true
  deletion_protection    = true
  vpc_security_group_ids = [aws_security_group.blog.id]

  tags = {
    Name = var.name
  }
}