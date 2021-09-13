resource "aws_ecs_cluster" "cluster" {
  name = "Todot"
}

data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

resource "aws_launch_template" "foobar" {
    name_prefix   = "foobar"
    image_id = data.aws_ssm_parameter.ecs_ami.value
    instance_type = "t2.micro"
    key_name = "Todo"
    update_default_version = true
    user_data = filebase64("userdata.sh")
    vpc_security_group_ids = [aws_security_group.ec2.id, aws_security_group.alb.id]
    iam_instance_profile {
      name = aws_iam_instance_profile.ec2_instance_profile.name
    }
}



