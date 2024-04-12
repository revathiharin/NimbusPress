import boto3

from variables import Variables

class AutoScaling:
    def __init__(self):
        self.autoscaling = boto3.client("autoscaling")
        self.created_ids = {}

    def create_launch_configuration(self, rds_endpoint, rds_username, rds_password, rds_dbname, security_group_id):
        # Read the content of userdata.sh
        with open(Variables.USER_DATA_SCRIPT_PATH, "r") as userdata_file:
            userdata_script = userdata_file.read()

        # Concatenate RDS details into the script
        #user_data = f"{userdata_script}\n{rds_dbname}\n{rds_username}\n{rds_password}\n{rds_endpoint}"
        user_data = userdata_script.format(
            DBName=rds_dbname,
            DBUser=rds_username,
            DBPassword=rds_password,
            RDS_ENDPOINT=rds_endpoint,
        )
        # Create Launch Configuration
        response = self.autoscaling.create_launch_configuration(
            LaunchConfigurationName="launch-config",
            ImageId=Variables.AMI_ID,
            InstanceType=Variables.INSTANCE_TYPE,
            KeyName=Variables.KEY_NAME,
            UserData=user_data,
            SecurityGroups=[security_group_id],
            InstanceMonitoring={"Enabled": False},  # Optionally disable detailed monitoring
            AssociatePublicIpAddress=True,  # If the instance is in a public subnet
        )

        print("Launch Configuration created:", response)

        # Store the Launch Configuration ID
        launch_configuration_id = response["ResponseMetadata"].get("LaunchConfigurationName")
        self.created_ids["launch_configuration_id"] = launch_configuration_id

    def create_auto_scaling_group(self, launch_configuration_name, subnet_ids):
        # Create Auto Scaling group
        autoscaling_group = self.autoscaling.create_auto_scaling_group(
            AutoScalingGroupName="auto-scaling-group",
            LaunchConfigurationName=launch_configuration_name,
            MinSize=1,
            MaxSize=4,
            DesiredCapacity=2,
            AvailabilityZones=["us-west-2a", "us-west-2b"],
            VPCZoneIdentifier=",".join(subnet_ids),  # Comma-separated list of subnet IDs
            # Add any other parameters as needed
        )

        print("Auto Scaling Group created:", autoscaling_group)

        # Store the Auto Scaling Group ID
        auto_scaling_group_id = autoscaling_group["AutoScalingGroupName"]
        self.created_ids["auto_scaling_group_id"] = auto_scaling_group_id
        return auto_scaling_group_id

    def get_created_ids(self):
        return self.created_ids
