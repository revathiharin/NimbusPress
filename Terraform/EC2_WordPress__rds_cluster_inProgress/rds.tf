# Create RDS Database
#creating DB Subnet Group
resource "aws_db_subnet_group" "rds_cluster_private" {
    name       = "rds_cluster_private_group"
    subnet_ids = [aws_subnet.private[0].id, aws_subnet.private[1].id]
  
    tags = {
        Name = "rds_cluster_private_Group"
    }
}
resource "aws_rds_cluster" "mysql" {
    cluster_identifier = var.rds_cluster_identifier
    database_name      = var.rds_db_name
    engine             = var.rds_engine
    engine_version     = var.rds_engine_version
    master_username    = var.rds_username
    master_password    = var.rds_password
    skip_final_snapshot = var.rds_skip_final_snapshot
    
    vpc_security_group_ids = [aws_security_group.rds_mysql.id]
    #Associate private subnet to db instance
    db_subnet_group_name = aws_db_subnet_group.rds_cluster_private.name
    tags = {
        Name = "rds_cluster_2024_03_11"
    }
}
  
/* 
This bit of code is for aws_db_instance. Working files are available in the path AwsNeueFische/AWS_Restart_Private_Data/TerraformAWSNF/Task_2024_03_11_db_instance
resource "aws_db_instance" "mysql" {
    allocated_storage    = var.rds_allocated_storage
    db_name              = var.rds_db_name
    engine               = var.rds_engine
    engine_version       = var.rds_engine_version
    instance_class       = var.rds_instance_class
    identifier           = var.rds_identifier
    
    username             = var.rds_username
    password             = var.rds_password
    skip_final_snapshot  = var.rds_skip_final_snapshot
    
    multi_az             = var.rds_multi_az
    storage_encrypted    = var.rds_storage_encrypted
    #backup_retention_period = 0
    
    vpc_security_group_ids = [aws_security_group.rds_mysql.id]
    #Associate private subnet to db instance
    db_subnet_group_name = aws_db_subnet_group.private.name
    
    tags = {
        Name = "rds_db_2024_03_11"
    }
} */
data "aws_rds_cluster" "mysql_data" {
    cluster_identifier = aws_rds_cluster.mysql.id
}
#Get Database name, username, password, endpoint from above RDS
output "rds_db_name" {
    value = data.aws_rds_cluster.mysql_data.database_name       #data.aws_db_instance.mysql_data.db_name
}
output "rds_username" {
    value = var.rds_username
}
output "rds_passwordword" {
    value = var.rds_password
    sensitive = true
}
output "rds_endpoint" {
    value = data.aws_rds_cluster.mysql_data.endpoint    #data.aws_db_instance.mysql_data.endpoint
}

