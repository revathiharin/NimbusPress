# Create RDS Database
#creating DB Subnet Group
resource "aws_db_subnet_group" "private" {
    name       = "private_group"
    subnet_ids = [aws_subnet.private[0].id, aws_subnet.private[1].id]
  
    tags = {
        Name = "Private_Group ${var.tagNameDate}"
    }
}

resource "aws_db_instance" "mysql" {
    allocated_storage    = "10"
    db_name              = var.rds_db_name
    engine               = "mysql"
    engine_version       = "8.0.35"
    instance_class       = "db.t3.micro"
    identifier           = "rds-db"
    
    username             = var.rds_username
    password             = var.rds_password
    skip_final_snapshot  = true
    
    multi_az             = false
    storage_encrypted    = false
    
    vpc_security_group_ids = [aws_security_group.rds_mysql.id]
    
    #Associate private subnet to db instance
    db_subnet_group_name = aws_db_subnet_group.private.name
    
    tags = {
        Name = "rds_db ${var.tagNameDate}"
    }
}
data "aws_db_instance" "mysql_data" {
    db_instance_identifier = aws_db_instance.mysql.identifier
}
#Get Database name, username, password, endpoint from above RDS
output "rds_db_name" {
    value = data.aws_db_instance.mysql_data.db_name
}
output "rds_username" {
    value = var.rds_username
}
output "rds_passwordword" {
    value = var.rds_password
    sensitive = true
}
output "rds_endpoint" {
    value = data.aws_db_instance.mysql_data.endpoint
}

