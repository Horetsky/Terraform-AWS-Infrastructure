variable "alb_dns_name" {}
variable "alb_zone_id" {}

variable "alb_services_domains" {
    default = ["api.demo.desqk.com", "upload.demo.desqk.com", "admin.demo.desqk.com"]
}

data "aws_route53_zone" "prod-desqk-hz" {
    name         = "desqk.com"
    private_zone = false
}

resource "aws_route53_record" "alb-record" {
    count = length(var.alb_services_domains)
    zone_id = data.aws_route53_zone.prod-desqk-hz.zone_id
    name    = element(var.alb_services_domains, count.index)
    type    = "A"

    alias {
        name                   = var.alb_dns_name
        zone_id                = var.alb_zone_id
        evaluate_target_health = true
    }
}