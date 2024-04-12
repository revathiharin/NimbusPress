# main.py
import json
from vpc import VPC
from security_group import SecurityGroup
from ec2_instance import EC2Instance
from rds import RDS
from autoscaling import AutoScaling
from alb import ALB

def main():
    # Create VPC
    vpc = VPC()
    vpc_id, public_subnet_ids, private_subnet_ids, route_table_id = vpc.create_vpc()

    # Define inbound rules for EC2 security group (SSH and HTTP)
    ec2_ingress_rules = [
        {"IpProtocol": "tcp", "FromPort": 22, "ToPort": 22, "CidrIp": "0.0.0.0/0"},
        {"IpProtocol": "tcp", "FromPort": 80, "ToPort": 80, "CidrIp": "0.0.0.0/0"}
    ]

    # Define inbound rule for RDS security group (MySQL)
    rds_ingress_rules = [
        {"IpProtocol": "tcp", "FromPort": 3306, "ToPort": 3306, "CidrIp": "0.0.0.0/0"}
    ]

    # Instantiate SecurityGroup class for EC2
    ec2_security_group = SecurityGroup(vpc_id)
    # Create security group for EC2 instances
    ec2_security_group_id = ec2_security_group.create_security_group("EC2SecurityGroup", "Security group for EC2 instances", ec2_ingress_rules)

    # Instantiate SecurityGroup class for RDS
    rds_security_group = SecurityGroup(vpc_id)
    # Create security group for RDS instances

    rds_security_group_id = rds_security_group.create_security_group("RDSSecurityGroup", "Security group for RDS instances", rds_ingress_rules)

    # Create RDS instance
    rds = RDS(vpc_id)  # Pass VPC ID to RDS constructor
    subnet_group_name = rds.create_subnet_group("subnet-group", private_subnet_ids, "Subnet group for rds")
    rds_endpoint, rds_username, rds_password, rds_dbname, rds_id = rds.create_rds_instance(rds_security_group_id,subnet_group_name)
    
    ec2_instance = EC2Instance(vpc_id, public_subnet_ids[0], ec2_security_group_id)
    ec2_instance_id = ec2_instance.create_ec2_instance(rds_endpoint, rds_username, rds_password, rds_dbname)

    # Create Auto Scaling Group
    autoscaling = AutoScaling()
    autoscaling.create_launch_configuration(rds_endpoint, rds_username, rds_password, rds_dbname, ec2_security_group_id)
    auto_scaling_group_id = autoscaling.create_auto_scaling_group("launch-config",private_subnet_ids)
    
    # Create Application Load Balancer
    alb = ALB()
    arn_alb=alb.create_load_balancer(public_subnet_ids, ec2_security_group_id)

    print("Infrastructure setup completed.")
    # Store resource IDs in a JSON file
    resource_ids = {
        "vpc_id": vpc_id,
        "public_subnet_ids": public_subnet_ids,
        "private_subnet_ids": private_subnet_ids,
        "route_table_id": route_table_id,
        "ec2_security_group_id": ec2_security_group_id,
        "rds_security_group_id": rds_security_group_id,
        "rds_instance_id": rds_id,
        "ec2_instance_id": ec2_instance_id,
        "auto_scaling_group_id": auto_scaling_group_id,
        "arn_alb": arn_alb
    }

    with open("resource_ids.json", "w") as json_file:
        json.dump(resource_ids, json_file)

if __name__ == "__main__":
    main()
