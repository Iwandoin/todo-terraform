resource "aws_autoscaling_group" "asg" {
  desired_capacity   = 1
  max_size           = 3
  min_size           = 1
  vpc_zone_identifier = aws_subnet.PublicAZ.*.id
  launch_template {
    id      = aws_launch_template.foobar.id
  }
}

resource "aws_autoscaling_policy" "asg-scale-up" {
    name = "asg-scale-up"
    scaling_adjustment = 1
    adjustment_type = "ChangeInCapacity"
    cooldown = 10
    autoscaling_group_name = aws_autoscaling_group.asg.name
}

resource "aws_autoscaling_policy" "asg-scale-down" {
    name = "asg-scale-down"
    scaling_adjustment = -1
    adjustment_type = "ChangeInCapacity"
    cooldown = 10
    autoscaling_group_name = aws_autoscaling_group.asg.name
}

resource "aws_cloudwatch_metric_alarm" "memory-high" {
    alarm_name = "mem-util-high"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = "1"
    metric_name = "MemoryReservation"
    namespace = "AWS/ECS"
    period = "60"
    statistic = "Average"
    threshold = "70"
    alarm_description = "This metric monitors ec2 memory for high utilization"
    alarm_actions = [
        aws_autoscaling_policy.asg-scale-up.arn
    ]
    dimensions = {
       ClusterName = aws_ecs_cluster.cluster.name
    }
}

resource "aws_cloudwatch_metric_alarm" "memory-low" {
    alarm_name = "mem-util-low"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods = "1"
    metric_name = "MemoryReservation"
    namespace = "AWS/ECS"
    period = "60"
    statistic = "Average"
    threshold = "30"
    alarm_description = "This metric monitors ec2 memory for low utilization"
    alarm_actions = [
        aws_autoscaling_policy.asg-scale-down.arn
    ]
    dimensions = {
        ClusterName = aws_ecs_cluster.cluster.name

    }
}
