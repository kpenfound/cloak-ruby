variable "region" {
  default = "us-east-1"
}

variable "aws_access_key" {
  default = ""
}

variable "aws_secret_key" {
  default = ""
}

variable "vpc_id" {
  default = ""
}

variable "name" {
  default = "blog"
}

variable "domain" {
  default = "kpenfound.io"
}

variable "fqdn" {
  default = "blog.kpenfound.io"
}

variable "db_class" {
  default = "db.t4g.medium"
}