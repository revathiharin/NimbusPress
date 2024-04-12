import json
import boto3

def destroy_resources(resource_ids):
    # Initialize AWS clients
    ec2 = boto3.client("ec2")
    rds = boto3.client("rds")
    autoscaling = boto3.client("autoscaling")
    elbv2 = boto3.client("elbv2")

    # Delete EC2 instance
    ec2.terminate_instances(InstanceIds=[resource_ids["ec2_instance_id"]])

    # Delete RDS instance
    rds.delete_db_instance(DBInstanceIdentifier=resource_ids["rds_instance_id"], SkipFinalSnapshot=True)

    # Delete Auto Scaling Group
    autoscaling.delete_auto_scaling_group(AutoScalingGroupName=resource_ids["autoscaling_group_name"], ForceDelete=True)

    # Delete Application Load Balancer
    elbv2.delete_load_balancer(LoadBalancerArn=resource_ids["alb_arn"])

    # Delete security groups, subnets, etc. (additional cleanup)
    # Delete EC2 Security Group
    ec2.delete_security_group(GroupId=resource_ids["ec2_security_group_id"])

    # Delete RDS Security Group
    ec2.delete_security_group(GroupId=resource_ids["rds_security_group_id"])

    # Delete subnets
    for subnet_id in resource_ids["public_subnet_ids"] + resource_ids["private_subnet_ids"]:
        ec2.delete_subnet(SubnetId=subnet_id)

    # Delete VPC
    ec2.delete_vpc(VpcId=resource_ids["vpc_id"])

# Read resource IDs from JSON file
with open("resource_ids.json", "r") as file:
    resource_ids = json.load(file)

# Call the destroy_resources function
destroy_resources(resource_ids)
