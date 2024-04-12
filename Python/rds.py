import boto3

class RDS:
    def __init__(self, vpc_id):
        self.rds = boto3.client("rds")
        self.vpc_id = vpc_id
    
    def create_subnet_group(self, subnet_group_name, subnet_ids, description):
        # Create DB subnet group
        response = self.rds.create_db_subnet_group(
            DBSubnetGroupName=subnet_group_name,
            DBSubnetGroupDescription=description,
            SubnetIds=subnet_ids
        )
        print("DB subnet group created:", response['DBSubnetGroup']['DBSubnetGroupName'])
        return subnet_group_name
    
    def create_rds_instance(self, security_group_id, subnet_group_name):
        # Hardcoded values
        rds_identifier = "rds-instance"
        rds_engine = "mysql"
        rds_instance_class = "db.t3.micro"
        rds_allocated_storage = 10
        rds_master_username = "admin"
        rds_master_password = "password"
        rds_db_name = "wordpress"

        # Create RDS instance
        rds_instance = self.rds.create_db_instance(
            DBInstanceIdentifier=rds_identifier,
            Engine=rds_engine,
            DBInstanceClass=rds_instance_class,
            AllocatedStorage=rds_allocated_storage,
            MasterUsername=rds_master_username,
            MasterUserPassword=rds_master_password,
            DBName=rds_db_name,
            VpcSecurityGroupIds=[security_group_id],
            DBSubnetGroupName=subnet_group_name,
            DeletionProtection=False,
            BackupRetentionPeriod=0,
            StorageEncrypted=False,
            MultiAZ=False
        )
        # Retrieve the RDS instance ID from the response
        
        print("RDS Instance ID:", rds_instance['DBInstance']['DBInstanceIdentifier'])
        print("RDS instance creation initiated.")

        # Wait until the RDS instance is available
        waiter = self.rds.get_waiter('db_instance_available')
        waiter.wait(DBInstanceIdentifier=rds_identifier)

        # Retrieve the endpoint
        response = self.rds.describe_db_instances(DBInstanceIdentifier=rds_identifier)
        rds_endpoint = response['DBInstances'][0]['Endpoint']['Address']
        rds_instance_id = response['DBInstances'][0]['DBInstanceIdentifier']
        print("RDS Endpoint:", rds_endpoint)

        return rds_endpoint, rds_master_username, rds_master_password, rds_db_name, rds_instance_id
