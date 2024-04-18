
resource "aws_launch_configuration" "scaling_launch_config" {
  image_id        = var.ami_id
  instance_type   = var.ec2_instance_type
  security_groups = ["${aws_security_group.wordpress_sg.id}"]
  key_name        = var.key_name
}

resource "aws_autoscaling_group" "wordpress_autoscaling_group" {
  #launch_configuration = aws_launch_configuration.scaling_launch_config.name
  launch_template {
    id      = aws_launch_template.scaling_launch_template.id
    version = "$Latest"                                   #aws_launch_template.wordpress_launch_template.latest_version
  }
  min_size             = var.min_size
  max_size             = var.max_size
  desired_capacity     = var.desired_capacity
  vpc_zone_identifier  = [aws_subnet.public[0].id, aws_subnet.public[1].id]    #var.private_subnet_cidr_blocks
  health_check_type    = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "Wordpress Instance AS"
    propagate_at_launch = true
  }
}

#Create a launch template
resource "aws_launch_template" "scaling_launch_template" {
  name_prefix   = "scaling_launch_template"
  image_id      = var.ami_id
  instance_type = var.ec2_instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.wordpress_sg.id]

  user_data = filebase64("UserData.sh")

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
