provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 1}.0/24"
  availability_zone = "ap-south-1${count.index + 1}"
}

module "eks_cluster" {
  source = "terraform-aws-modules/eks/aws"
  cluster_name    = "EKS-1"
  cluster_version = "1.21"
  subnets         = aws_subnet.public.*.id
  vpc_id          = aws_vpc.main.id
}

resource "aws_db_instance" "example" {
  identifier           = "mydbinstance"
  engine               = "mysql"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  username             = "admin"
  password             = "password"
  db_name              = "mydb"
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]
}