variable "vpc_id" {}
variable "lb_target_group_name" {}
variable "lb_target_group_port" {}
variable "lb_target_group_protocol" {}


output "prod-desqk-lb-target-group-arn" {
  value = aws_lb_target_group.prod-desqk-lb-target-group.arn
}

resource "aws_lb_target_group" "prod-desqk-lb-target-group" {
  name     = var.lb_target_group_name
  port     = var.lb_target_group_port
  protocol = var.lb_target_group_protocol
  vpc_id   = var.vpc_id
  health_check {
    path                = "/api"
    port                = 80
    healthy_threshold   = 6
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5
    matcher             = "200"
  }

  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400  # Тривалість дії cookie в секундах (1 день)
  }
}