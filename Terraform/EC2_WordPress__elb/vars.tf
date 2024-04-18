variable "region" {
  description = "AWS region"
  default     = "us-west-2"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}
variable "cidr_blocks" {
  default     = ["0.0.0.0/0"]
}  

variable "enable_dns_support" {
  description = "Enable DNS support for the VPC"
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames for the VPC"
  default     = true
}

variable "availability_zones" {
  description = "List of availability zones"
  default     = ["us-west-2a", "us-west-2b"]  # Replace with your availability zones
}

variable "public_subnet_cidr_blocks" {
  description = "CIDR blocks for public subnets"
  default     = ["10.0.0.0/24", "10.0.1.0/24"]  # Adjust as needed
}

variable "private_subnet_cidr_blocks" {
  description = "CIDR blocks for private subnets"
  default     = ["10.0.2.0/24", "10.0.3.0/24"]  # Adjust as needed
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-0d442a425e2e0a743"
  
  #"ami-0d442a425e2e0a743" # Example: Amazon Linux 2 HVM -amzn2-ami-kernel-5.10-hvm-2.0.20240131.0-x86_64-gp2
  #ami-0895022f3dac85884 #Amazon Linux 2 Kernel 5.10 AMI 2.0.20240223.0 x86_64 HVM gp2
}

variable "key_name" {
  description = "Name of the EC2 key pair"
  default     = "vockey"
}

variable "min_size" {
  description = "The minimum number of instances in the autoscaling group"
  default     = 1
}

variable "max_size" {
  description = "The maximum number of instances in the autoscaling group"
  default     = 4
}

variable "desired_capacity" {
  description = "The desired capacity of the autoscaling group"
  default     = 2
}
