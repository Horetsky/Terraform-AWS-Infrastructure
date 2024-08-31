resource "aws_autoscaling_policy" "scale_up" {
    name                   = "prod-desqk-asg-scale-up"
    autoscaling_group_name = aws_autoscaling_group.prod-desqk-asg.name
    adjustment_type        = "ChangeInCapacity"
    scaling_adjustment     = "1" #increasing instance by 1
    cooldown               = "300"
    policy_type            = "SimpleScaling"
}

# scale down policy
resource "aws_autoscaling_policy" "scale_down" {
    name                   = "prod-desqk-asg-scale-down"
    autoscaling_group_name = aws_autoscaling_group.prod-desqk-asg.name
    adjustment_type        = "ChangeInCapacity"
    scaling_adjustment     = "-1" # decreasing instance by 1
    cooldown               = "300"
    policy_type            = "SimpleScaling"
}