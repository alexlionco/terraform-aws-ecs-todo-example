resource "aws_security_group" "ecs_sg" {
  vpc_id = var.vpc_id

  ingress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port        = 80
    protocol         = "tcp"
    to_port          = 80
    prefix_list_ids  = []
    description      = "HTTP"
    security_groups  = []
    self             = true
  }]

  egress = [{
    from_port        = 0
    protocol         = "tcp"
    to_port          = 65535
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    description      = "ALL TCP"
    security_groups  = []
    self             = true
  }]
}

data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

resource "aws_ecr_repository" "ecr_repo" {
  name = "todoapp"
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "todoapp-cluster"
}

data "template_file" "task_template" {
  template = file("${path.module}/task.json.tpl")
  vars = {
    REPOSITORY_URL = replace(replace("${aws_ecr_repository.ecr_repo.repository_url}", "https://", ""), ":5432", "")
    REGION         = "eu-west-3"
    REDIS          = "${var.redis_endpoint}"
    POSTGRES       = "${var.pg_endpoint}"
    DB_USERNAME    = "${var.db_username}"
    DB_PASSWORD    = "${var.db_password}"
  }
}

resource "aws_ecs_task_definition" "task_ecs" {
  family                = "todoapp"
  container_definitions = data.template_file.task_template.rendered
  requires_compatibilities = [ "FARGATE" ]
  network_mode = "awsvpc"
  cpu = 256
  memory = 512
  execution_role_arn = "${data.aws_iam_role.ecs_task_execution_role.arn}"
}

resource "aws_ecs_service" "todoapp" {
  name            = "todoapp"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_ecs.arn
  desired_count   = 1
  launch_type = "FARGATE"
  network_configuration {
    security_groups = ["${aws_security_group.ecs_sg.id}"]
    subnets         = var.subnet_ids
  }
}