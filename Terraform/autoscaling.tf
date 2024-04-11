
resource "aws_launch_configuration" "scaling_launch_config" {
  image_id        = data.aws_ami.amazon_linux.id
  instance_type   = var.ec2_instance_type
  security_groups = ["${aws_security_group.wordpress_sg.id}"]
  key_name        = var.key_name
  user_data       = filebase64(stress.sh)
}

resource "aws_autoscaling_group" "wordpress_autoscaling_group" {
  #launch_configuration = aws_launch_configuration.scaling_launch_config.name
  launch_template {
    id      = aws_launch_template.scaling_launch_template.id
    version = "$Latest" #aws_launch_template.wordpress_launch_template.latest_version
  }
  min_size                  = 1
  max_size                  = 4
  desired_capacity          = 1
  vpc_zone_identifier       = [aws_subnet.public[0].id, aws_subnet.public[1].id] #var.private_subnet_cidr_blocks
  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "Wordpress_Instance_AS ${var.tagNameDate}"
    propagate_at_launch = true
  }
}

#Create a launch template
resource "aws_launch_template" "scaling_launch_template" {
  name_prefix   = "scaling_launch_template"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.ec2_instance_type

  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.wordpress_sg.id]

  user_data = base64encode(data.template_file.userdataEC.rendered)

  lifecycle {
    create_before_destroy = true
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "WordPress Instance AS"
    }
  }
}

resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale_out"
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.wordpress_autoscaling_group.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60.0
  }
}
resource "aws_autoscaling_policy" "scale_in" {
  name                   = "scale_in"
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.wordpress_autoscaling_group.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 30.0
  }
}
