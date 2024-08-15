variable "vpc_id" {}
variable "ec2_instance_id" {}

variable "subnet_ids" {}
variable "security_groups" {}

module "balancing-target-group" {
  source                   = "./target-group"
  vpc_id                   = var.vpc_id
  ec2_instance_id          = var.ec2_instance_id
  lb_target_group_name     = "prod-desqk-lb-tg"
  lb_target_group_port     = 80
  lb_target_group_protocol = "HTTP"
}

module "balancing-load-balancer" {
  source                     = "./load-balancer"
  lb_name                    = "prod-desk-alb"
  lb_type                    = "application"
  subnet_ids                 = var.subnet_ids
  security_groups            = var.security_groups
  lb_target_group_arn        = module.balancing-target-group.prod-desqk-lb-target-group-arn
  lb_listener_port           = 80
  lb_listener_protocol       = "HTTP"
  lb_listener_default_action = "forward"
}