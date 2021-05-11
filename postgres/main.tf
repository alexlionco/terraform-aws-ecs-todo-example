resource "aws_security_group" "rds_sg" {
  vpc_id = var.vpc_id


  ingress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port        = 5432
    protocol         = "tcp"
    to_port          = 5432
    security_groups  = []
    prefix_list_ids  = []
    description      = "Postgres"
    self             = true
  }]

  egress = [{
    from_port        = 0
    protocol         = "tcp"
    to_port          = 65535
    ipv6_cidr_blocks = ["::/0"]
    cidr_blocks      = ["0.0.0.0/0"]
    prefix_list_ids  = []
    description      = "ALL TCP"
    security_groups  = []
    self             = true
  }]
}


resource "aws_db_subnet_group" "rds_subnet_grp" {
  name       = "db-subnet-grp-todoapp"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "db" {
  allocated_storage    = 5
  engine               = "postgres"
  engine_version       = "12.5"
  instance_class       = "db.t3.micro"
  name                 = "todoapp"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.postgres12"
  skip_final_snapshot  = true
  db_subnet_group_name = "${aws_db_subnet_group.rds_subnet_grp.id}"
  vpc_security_group_ids = [ aws_security_group.rds_sg.id ]
}