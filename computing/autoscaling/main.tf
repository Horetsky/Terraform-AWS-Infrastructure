variable "subnet_ids" {}

variable "launch_template_id" {}
variable "target_group_arns" {}

variable "desired_size" {}
variable "max_size" {}
variable "min_size" {}

variable "scale_up_threshold" { default = "60" }
variable "scale_down_threshold" { default = "5" }

resource "aws_autoscaling_group" "prod-desqk-asg" {
    vpc_zone_identifier = var.subnet_ids

    desired_capacity     = var.desired_size
    max_size             = var.max_size
    min_size             = var.min_size

    target_group_arns = var.target_group_arns

    launch_template {
        id      = var.launch_template_id
        version = "$Latest"
    }

    tag {
        key                 = "Name"
        value               = "Desqk Prod Server"
        propagate_at_launch = true
    }
}