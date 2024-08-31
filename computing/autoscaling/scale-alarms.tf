
# scale up alarm
resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
    alarm_name          = "prod-desqk-asg-scale-up-alarm"
    alarm_description   = "asg-scale-up-cpu-alarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = "2"
    metric_name         = "CPUUtilization"
    namespace           = "AWS/EC2"
    period              = "120"
    statistic           = "Average"
    threshold           = var.scale_up_threshold # New instance will be created once CPU utilization is higher than 30 %
    dimensions = {
        "AutoScalingGroupName" = aws_autoscaling_group.prod-desqk-asg.name
    }
    actions_enabled = true
    alarm_actions   = [aws_autoscaling_policy.scale_up.arn]
}

# scale down alarm
resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
    alarm_name          = "prod-desqk-asg-scale-down-alarm"
    alarm_description   = "asg-scale-down-cpu-alarm"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods  = "2"
    metric_name         = "CPUUtilization"
    namespace           = "AWS/EC2"
    period              = "120"
    statistic           = "Average"
    threshold           = var.scale_down_threshold # Instance will scale down when CPU utilization is lower than 5 %
    dimensions = {
        "AutoScalingGroupName" = aws_autoscaling_group.prod-desqk-asg.name
    }
    actions_enabled = true
    alarm_actions   = [aws_autoscaling_policy.scale_down.arn]
}