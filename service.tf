resource "aws_ecs_service" "ecs_service" {
  name = "todot_service"
  cluster = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.ecs_td.family
  desired_count   = 1
  #iam_role = aws_iam_role.ecsTaskExecutionRole.name
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent = 200
  health_check_grace_period_seconds = 120
  load_balancer {
    target_group_arn = aws_alb_target_group.default.arn
    container_name = "todot"
    container_port = "8000"
  }
  lifecycle {
    ignore_changes = [desired_count]
  }
}

resource "aws_appautoscaling_target" "ecs_target_up" {
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "service/Todot/todot_service"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}


resource "aws_appautoscaling_target" "ecs_target_down" {
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "service/Todot/todot_service"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}



resource "aws_appautoscaling_policy" "service_scale_up" {
  name               = "scale-up"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_target_up.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target_up.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target_up.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 0
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = null
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
}



resource "aws_appautoscaling_policy" "service_scale_down" {
  name               = "scale-down"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_target_down.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target_down.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target_down.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 0
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      metric_interval_lower_bound = null
      scaling_adjustment          = -1
    }
  }
}


resource "aws_cloudwatch_metric_alarm" "high" {
    alarm_name = "high"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = "1"
    metric_name = "RequestCountPerTarget"
    namespace = "AWS/ApplicationELB"
    period = "60"
    statistic = "Average"
    threshold = "0.25"
    alarm_description = "This metric monitors ec2 memory for high utilization on agent hosts"
    alarm_actions = [
        aws_appautoscaling_policy.service_scale_up.arn
    ]
    dimensions = {
      LoadBalancer = aws_alb.default.arn_suffix
      TargetGroup = aws_alb_target_group.default.arn_suffix
    }
}

resource "aws_cloudwatch_metric_alarm" "low" {
    alarm_name = "low"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods = "1"
    metric_name = "RequestCountPerTarget"
    namespace = "AWS/ApplicationELB"
    period = "60"
    statistic = "Average"
    threshold = "0.125"
    alarm_description = "This metric monitors ec2 memory for low utilization on agent hosts"
    alarm_actions = [
        aws_appautoscaling_policy.service_scale_down.arn
    ]
    dimensions = {
      LoadBalancer = aws_alb.default.arn_suffix
      TargetGroup = aws_alb_target_group.default.arn_suffix
    }
}