locals {
  name = "WordPress Instance_${var.tagNameDate}"
}
#Get latest ami ID of Amazon Linux - values = ["al2023-ami-2023*x86_64"]
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*x86_64"]
    #values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "wordpress_instance" {
  ami = var.ami_id                                    #data.aws_ami.amazon_linux.id          
  instance_type = var.ec2_instance_type
  availability_zone = var.availability_zones[0]
  key_name = var.key_name
  iam_instance_profile = var.LabRoleARN     #aws_iam_instance_profile.wordpress_profile.name
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.wordpress_sg.id ]
  subnet_id     = aws_subnet.public[0].id  # Choose one of the public subnets
  #security_groups = [aws_security_group.wordpress_sg.name]

  tags = {
    Name = local.name
  }
  #user_data = file("UserData.sh")
  user_data = "${data.template_file.userdata.rendered}"
  provisioner "remote-exec" {
    inline = [
    # "while [ ! -f /var/log/cloud-init-output.log ] || ! sudo grep 'Cloud-init .* finished' /var/log/cloud-init-output.log ; do sleep 10; done"
    "while ! sudo grep -q 'Userdata execution completed' /var/log/userdata.log; do sleep 10; done"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user" # Change this if your user is different
      private_key = file("labsuser.pem") # Change this to your private key path
      host        = aws_instance.wordpress_instance.public_ip # You may need to change this based on your configuration
    }
  }
  
}

data "template_file" "userdata" {
  template = "${file("UserDataEC2.sh")}"

  vars = {
    rds_endpoint = replace("${data.aws_db_instance.mysql_data.endpoint}",":3306","")#"${data.aws_db_instance.mysql_data.endpoint}"
    rds_username = "${var.rds_username}"
    rds_password = "${var.rds_password}"
    rds_db_name = "${data.aws_db_instance.mysql_data.db_name}"
    s3_bucket_name = "${var.s3_bucket_name_temp}"  #"${aws_s3_bucket.wordpress.bucket}"
  }
} 
#s3_bucketName = "${aws_s3_bucket.wordpress.bucket}"

#S3_BucketName=${s3_bucketName}
#test
#admin
# WBF*cCkQ6C4!3Bl^&L
#http://54.200.248.233/wp-login.php
