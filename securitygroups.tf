resource "aws_security_group" "ecs_alb_sg" {
  name        = "${var.ecs_cluster_name}-LB-SG"
  description = "Security group for LB to traffic for ECS cluster"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    cidr_blocks = [var.inet_cidr_block]
    from_port   = 443
    protocol    = "TCP"
    to_port     = 443
  }

ingress {
    cidr_blocks = [var.inet_cidr_block]
    from_port   = 80
    protocol    = "TCP"
    to_port     = 80
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = [var.inet_cidr_block]
  }
}

resource "aws_security_group" "app_sg" {
  name        = "${var.ecs_service_name}-SG"
  description = "Application security group to communicate in and out"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    cidr_blocks = [aws_vpc.vpc.cidr_block]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = [var.inet_cidr_block]
  }

  tags = {
    Name = "${var.ecs_service_name}-SG"
  }
}
