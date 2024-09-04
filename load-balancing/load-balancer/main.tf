variable "lb_name" {}
variable "lb_type" {}

variable "subnet_ids" {}
variable "security_groups" {}
variable "lb_target_group_arn" {}

variable "prod_desqk_acm_arn" {}
variable "lb_listener_default_action" { default = "forward" }

variable "lb_http_listener_port" { default = 80 }
variable "lb_http_listener_protocol" { default = "HTTP" }
variable "lb_https_listener_port" { default = 443 }
variable "lb_https_listener_protocol" { default = "HTTPS" }

output "alb_dns_name" {
    value = aws_lb.prod-desqk-lb.dns_name
}

output "alb_zone_id" {
    value = aws_lb.prod-desqk-lb.zone_id
}

resource "aws_lb" "prod-desqk-lb" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = var.lb_type
  security_groups    = var.security_groups
  subnets            = var.subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = "prod-desqk-alb"
  }
}

resource "aws_lb_listener" "prod-desqk-lb-http-listener" {
  load_balancer_arn = aws_lb.prod-desqk-lb.arn
  port              = var.lb_http_listener_port
  protocol          = var.lb_http_listener_protocol

  default_action {
      type = "redirect"

      redirect {
          port        = "443"
          protocol    = "HTTPS"
          status_code = "HTTP_301"
      }
  }
}

# HTTPS listener
resource "aws_lb_listener" "prod-desqk-lb-https-listener" {
    load_balancer_arn = aws_lb.prod-desqk-lb.arn
    port              = var.lb_https_listener_port
    protocol          = var.lb_https_listener_protocol
    ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
    certificate_arn   = var.prod_desqk_acm_arn

    default_action {
        type             = var.lb_listener_default_action
        target_group_arn = var.lb_target_group_arn
    }
}