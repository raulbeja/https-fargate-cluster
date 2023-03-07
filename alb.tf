resource "aws_alb" "ecs_alb" {
  name            = "${var.ecs_cluster_name}-ALB"
  internal        = false
  security_groups = [aws_security_group.ecs_alb_sg.id]
  subnets         = [for subnet in aws_subnet.pub_subnet : subnet.id]
  tags = merge(local.common_tags, {
    Name = "${var.ecs_cluster_name}-ALB"
  })
}

resource "aws_alb_target_group" "ecs_alb_tg" {
  name     = "${var.ecs_cluster_name}-TG"
  port     = 80
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = aws_vpc.vpc.id

  tags = {
    Name = "${var.ecs_cluster_name}-TG"
  }
}

resource "aws_alb_listener" "ecs_alb_http_listener" {
  load_balancer_arn = aws_alb.ecs_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "ecs_alb_https_listener" {
  load_balancer_arn = aws_alb.ecs_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = data.aws_acm_certificate.ecs_domain_certificate.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.ecs_alb_tg.arn
  }

  depends_on = [aws_alb_target_group.ecs_alb_tg]
}

resource "aws_route53_record" "ecs_lb_record" {
  name    = "${var.ecs_cluster_name}.${var.ecs_domain_name}"
  type    = "A"
  zone_id = data.aws_route53_zone.domain.zone_id

  alias {
    evaluate_target_health = false
    name                   = aws_alb.ecs_alb.dns_name
    zone_id                = aws_alb.ecs_alb.zone_id
  }
}