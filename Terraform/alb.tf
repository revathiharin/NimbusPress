resource "aws_lb" "wordpress_alb" {
  name               = "wordpress-alb"
  internal           = false              # Set to true if the ALB should be internal
  load_balancer_type = "application"
  subnets            = [aws_subnet.public[0].id, aws_subnet.public[1].id]       # Specify your public subnet(s) here
  security_groups    = [aws_security_group.wordpress_sg.id]

  enable_deletion_protection = false      # Set to true to prevent accidental deletion

  tags = {
    Name = "wordpress_alb ${var.tagNameDate}"
  }
}

resource "aws_lb_target_group" "Wordpress_target_group" {
  name        = "wordpress-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "instance"

  # Add tags
  tags = {
    Name = "wordpress-target-group ${var.tagNameDate}"
  }
}

resource "aws_lb_target_group_attachment" "wordpress_target_group_attachment" {
  target_group_arn = aws_lb_target_group.Wordpress_target_group.arn
  target_id        = aws_instance.wordpress_instance.id
  port             = 80
}

resource "aws_lb_listener" "wordpress_listener" {
  load_balancer_arn = aws_lb.wordpress_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Wordpress_target_group.arn
  }
}

