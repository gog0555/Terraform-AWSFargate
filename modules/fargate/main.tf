resource "aws_ecs_cluster" "cluster" {
  name = "${var.env}-${var.name}-cluster"
}

resource "aws_ecs_cluster_capacity_providers" "providers" {
  cluster_name = aws_ecs_cluster.cluster.name

  capacity_providers = [var.capacity_provider]

  default_capacity_provider_strategy {
    capacity_provider = var.capacity_provider
  }
}


resource "aws_ecs_task_definition" "task" {
  family                = "httpd"
  container_definitions = file("./container_difinitions.json")

  cpu                      = var.ecs_task.cpu
  memory                   = var.ecs_task.memory

  network_mode = var.ecs_task.network_mode
  requires_compatibilities = [var.capacity_provider]
}


resource "aws_security_group" "fargate_sg" {
  name        = "allow_http"
  description = "Allow http inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

  tags = {
    Name = "${var.env}-${var.name}-sg"
  }
}


resource "aws_ecs_service" "httpd_service" {
  name            = "${var.env}-${var.name}-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = var.desired_count

  capacity_provider_strategy {
    capacity_provider = var.capacity_provider
    weight = var.fargate_weight
  }

  network_configuration {
    subnets = [var.public_subnets[0]]
    security_groups = [aws_security_group.fargate_sg.id]
    assign_public_ip = "true"
  }
  
  lifecycle {
    ignore_changes = [task_definition]
  }

}