resource "aws_security_group" "alb" {
  description = "security-group--alb"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  name = "security-group--alb"

  tags = {
    Env  = "production"
    Name = "security-group--alb"
  }

  vpc_id = aws_vpc.todo_vpc.id
}


resource "aws_alb" "default" {
  name            = "alb"
  security_groups = [aws_security_group.alb.id]
  subnets = aws_subnet.PublicAZ.*.id
}

resource "aws_alb_target_group" "default" {
  health_check {
    healthy_threshold = 5
    unhealthy_threshold = 2
    timeout = 5
    interval = 10
    path = "/api"
    protocol = "HTTP"
    matcher = "200-399"
  }

  name     = "alb-target-group"
  port     = 80
  protocol = "HTTP"

  stickiness {
    type = "lb_cookie"
  }

  vpc_id = aws_vpc.todo_vpc.id
}

//resource "aws_alb_listener" "default" {
//  default_action {
//    target_group_arn = aws_alb_target_group.default.arn
//    type             = "forward"
//  }
//
//  load_balancer_arn = aws_alb.default.arn
//  port              = 80
//  protocol          = "HTTP"
//}

resource "aws_alb_listener" "secure" {
  default_action {
    target_group_arn = aws_alb_target_group.default.arn
    type             = "forward"
  }
  load_balancer_arn = aws_alb.default.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.cert_alb.arn
}
