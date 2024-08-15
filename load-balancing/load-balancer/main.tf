variable "lb_name" {}
variable "lb_type" {}

variable "subnet_ids" {}
variable "security_groups" {}
variable "lb_target_group_arn" {}

variable "lb_listener_port" {}
variable "lb_listener_protocol" {}
variable "lb_listener_default_action" {}

# variable "lb_https_listener_port" {}
# variable "lb_https_listener_protocol" {}
# variable "dev_proj_1_acm_arn" {}

resource "aws_lb" "prod-desqk-lb" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = var.lb_type
  security_groups    = var.security_groups
  subnets            = var.subnet_ids # Replace with your subnet IDs

  enable_deletion_protection = false

  tags = {
    Name = "prod-desqk-alb"
  }
}

resource "aws_lb_listener" "prod-desqk-lb-http-listener" {
  load_balancer_arn = aws_lb.prod-desqk-lb.arn
  port              = var.lb_listener_port
  protocol          = var.lb_listener_protocol

  default_action {
    type             = var.lb_listener_default_action
    target_group_arn = var.lb_target_group_arn
  }
}

# https listener on port 443
# resource "aws_lb_listener" "prod-desqk-lb-https-listener" {
#     load_balancer_arn = aws_lb.prod-desqk-lb.arn
#     port              = var.lb_https_listener_port
#     protocol          = var.lb_https_listener_protocol
#     ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2019-08"
#     certificate_arn   = var.dev_proj_1_acm_arn
#
#     default_action {
#         type             = var.lb_listener_default_action
#         target_group_arn = var.lb_target_group_arn
#     }
# }