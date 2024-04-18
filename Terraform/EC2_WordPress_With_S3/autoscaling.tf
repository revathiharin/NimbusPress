
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
    value               = "Wordpress_Instance_AS_${var.tagNameDate}"
    propagate_at_launch = true
  } 
}

#Create a launch template
resource "aws_launch_template" "scaling_launch_template" {
  name_prefix   = "scaling_launch_template"
  image_id      = var.ami_id
  instance_type = var.ec2_instance_type

  iam_instance_profile {
    name = var.LabRoleARN
  }
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.wordpress_sg.id]

  #user_data = filebase64("UserDataEC2.sh")
  #user_data = "${data.template_file.userdataAS.rendered}"
  user_data =  base64encode(data.template_file.userdataAS.rendered)

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
 
data "template_file" "userdataAS" {
  template = "${file("UserDataAS.sh")}"

  vars = {
    ec2_instance_id = "${aws_instance.wordpress_instance.id}"
    s3_bucket_name = "${var.s3_bucket_name_temp}"
  }
}  
#s3_bucketName = "${aws_s3_bucket.wordpress.bucket}"

    #rds_endpoint = replace("${data.aws_db_instance.mysql_data.endpoint}",":3306","")#"${data.aws_db_instance.mysql_data.endpoint}"
    #rds_username = "${var.rds_username}"
    #rds_password = "${var.rds_password}"
    #rds_db_name = "${data.aws_db_instance.mysql_data.db_name}"
