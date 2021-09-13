data "template_file" "task_definition" {
  template = file("td.json")
  vars = {
    image_url = "public.ecr.aws/l6a6l2j9/backendforst:latest"
    container_name = "todot_backend"
    log_group_region = var.aws_region
    log_group_name = "todot_backend"
    db_url = aws_db_instance.rds-instance.address
  }
}

resource "aws_ecs_task_definition" "ecs_td" {
  family = "todot_backend"
  cpu = 256
  memory = 256
  container_definitions = data.template_file.task_definition.rendered
  #execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  #task_role_arn            = aws_iam_role.InstanceRole.arn
}
