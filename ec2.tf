# Updated ec2.tf

resource "aws_launch_template" "app_template" {
  name_prefix   = "devops-app-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  user_data = filebase64("${path.module}/userdata.sh")

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.ec2_sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "DevOps-App"
      Role = "app"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app_asg" {
  name                      = "app-asg"
  max_size                  = 2
  min_size                  = 2
  desired_capacity          = 2
  target_group_arns         = [aws_lb_target_group.app_tg.arn]
  vpc_zone_identifier       = [
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

resource "aws_instance" "bi_instance" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  key_name               = var.key_name
  subnet_id              = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]


  user_data = filebase64("${path.module}/bi_userdata.sh")
  user_data_replace_on_change = true
  tags = {
    Name = "metabase-bi"
    Role = "bi"
  }
}

resource "aws_eip" "bi_eip" {
  instance = aws_instance.bi_instance.id
  tags = {
    Name = "bi-eip"
  }
}