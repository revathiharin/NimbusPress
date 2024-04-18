locals {
  name = "WordPress Instance"
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
  ami = var.ami_id              #data.aws_ami.amazon_linux.id          
  instance_type = var.ec2_instance_type
  availability_zone = var.availability_zones[0]
  key_name = var.key_name
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.wordpress_sg.id ]
  subnet_id     = aws_subnet.public[0].id  # Choose one of the public subnets
  #security_groups = [aws_security_group.wordpress_sg.name]

  tags = {
    Name = local.name
  }

  user_data = file("UserData.sh")
  /*
  # Connection configuration for provisioner
  connection {
    type        = "ssh"
    user        = "ec2-user"  # Replace with the appropriate username for your AMI
    private_key = file(var.private_key_path)  # Path to the SSH private key
    host        = self.public_ip  # Use the public IP address of the EC2 instance
  }
  # Run shell script to install software
  provisioner "remote-exec" {
    inline = [
      "chmod +x install_wordpress.sh",
      "./install_wordpress.sh"
    ]
  }*/
}
