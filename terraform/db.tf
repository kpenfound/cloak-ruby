resource "random_password" "db" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_db_instance" "blog" {
  engine                 = "aurora"
  instance_class         = "db.t4g"
  db_name                = var.name
  username               = var.name
  password               = random_password.db.result
  skip_final_snapshot    = true
  deletion_protection    = true
  vpc_security_group_ids = [aws_security_group.blog.id]
}