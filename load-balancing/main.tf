variable "vpc_id" {}

variable "subnet_ids" {}
variable "security_groups" {}

output "target_group_arn" {
  value = module.balancing-target-group.prod-desqk-lb-target-group-arn
}

output "alb_dns_name" {
  value = module.balancing-load-balancer.alb_dns_name
}

output "alb_zone_id" {
  value = module.balancing-load-balancer.alb_zone_id
}

data "aws_acm_certificate" "prod-desqk-https-certificate" {
  domain   = "api.demo.desqk.com"
  statuses = ["ISSUED"]

  # Опціонально можна уточнити, який саме сертифікат отримати
  most_recent = true
}

module "balancing-target-group" {
  source                   = "./target-group"
  vpc_id                   = var.vpc_id
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
  prod_desqk_acm_arn = data.aws_acm_certificate.prod-desqk-https-certificate.arn
}