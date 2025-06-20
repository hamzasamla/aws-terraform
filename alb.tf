# Application Load Balancer
resource "aws_lb" "app_alb" {
  name               = "app-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id,
  ]

  tags = {
    Name = "app-alb"
  }
}

# HTTP Listener
# resource "aws_lb_listener" "http" {
#   load_balancer_arn = aws_lb.app_alb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.app_tg.arn
#   }
# }

# HTTPS Listener (requires you to supply a valid ACM certificate ARN)
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
resource "aws_lb_listener_rule" "metabase" {
  listener_arn = aws_lb_listener.https.arn
  
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.metabase_tg.arn
  }

  condition {
    host_header {
      values = ["metabase-bi.sky98.store"]
    }
  }
}

resource "aws_lb_target_group" "metabase_tg" {
  name        = "metabase-tg"
  port        = 3001
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main_vpc.id
  target_type = "instance"

  health_check {
    path    = "/api/health"
    port    = "3001"
    matcher = "200"
  }
}

resource "aws_lb_target_group_attachment" "metabase" {
  target_group_arn = aws_lb_target_group.metabase_tg.arn
  target_id        = aws_instance.bi_instance.id
  port             = 3001
}