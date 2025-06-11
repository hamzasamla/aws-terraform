resource "aws_launch_template" "app_template" {
  name_prefix   = "devops-app-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  tags = {
    version = "v2"
  }

  user_data = filebase64("${path.module}/userdata.sh")

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.ec2_sg.id]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app_asg" {
  name                      = "app-asg"
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 2
  # forward traffic to our new target group
  target_group_arns = [ aws_lb_target_group.app_tg.arn ]
  vpc_zone_identifier       =  [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id,
  ]
  launch_template {
    id      = aws_launch_template.app_template.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "DevOps-App-Instance"
    propagate_at_launch = true
  }
}
