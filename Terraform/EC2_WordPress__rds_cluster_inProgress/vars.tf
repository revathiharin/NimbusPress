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

/* variable "rds_endpoint" {
  description = "The endpoint of the RDS instance"
} */

# Variables for RDS DB instance
variable "rds_identifier" {
  description = "The name of the RDS instance"
  default     = "rds-db-2024-03-11"
}
variable "rds_cluster_identifier" {
  description = "The name of the RDS cluster"
  default     = "rds-cluster-2024-03-11"
}
variable "rds_engine" {
  description = "The database engine to use"
  default     = "mysql"
}
variable "rds_engine_version" {
  description = "The engine version to use"
  default     = "8.0.35"
}
variable "rds_instance_class" {
  description = "The instance type of the RDS instance"
  default     = "db.t3.medium"
}
variable "rds_username" {
  description = "The username for the RDS instance"
  default     = "admin"
}
variable "rds_password" {
  description = "The password for the RDS instance"
  default     = "admin123"
  sensitive   = true
}
variable "rds_db_name" {
  description = "The name of the database"
  default     = "wordpressDb"
}
variable "rds_allocated_storage" {
  description = "The allocated storage in GB for the RDS instance"
  default     = "10"
}
variable "rds_storage_type" {
  description = "The storage type for the RDS instance"
  default     = "gp2"
}
variable "rds_multi_az" {
  description = "Whether to enable multi-AZ for the RDS instance"
  default     = "true"
}
variable "rds_publicly_accessible" {
  description = "Whether the RDS instance is publicly accessible"
  default     = "false"
}
variable "rds_skip_final_snapshot" {
  description = "Whether to skip the final snapshot before deleting the RDS instance"
  default     = "true"
}
variable "rds_port" {
  description = "The port number for the RDS instance"
  default     = "3306"
}
variable "rds_storage_encrypted" {
  description = "Whether to enable storage encryption for the RDS instance"
  default     = "true"
}