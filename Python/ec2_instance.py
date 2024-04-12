# ec2_instance.py
import boto3
from variables import Variables


class EC2Instance:
    def __init__(self, vpc_id, subnet_id, security_group_id):
        self.ec2 = boto3.resource("ec2")
        self.vpc_id = vpc_id
        self.subnet_id = subnet_id
        self.security_group_id = security_group_id
        self.instance_id = None

    def create_ec2_instance(self, rds_endpoint, rds_username, rds_password, rds_dbname):
        # Get latest Amazon Linux AMI ID
        filters = [{"Name": "name", "Values": ["amzn2-ami-hvm-*"]}]
        images = list(
            self.ec2.images.filter(Owners=[Variables.AMI_OWNER_ID], Filters=filters)
        )
        images.sort(key=lambda x: x.creation_date, reverse=True)
        # ami_id = images[0].id
        ami_id = Variables.AMI_ID
        # Read the content of userdata.sh
        with open(Variables.USER_DATA_SCRIPT_PATH, "r") as userdata_file:
            userdata_script = userdata_file.read()

        # Concatenate RDS details into the script
        #user_data = f"{userdata_script}\n{rds_dbname}\n{rds_username}\n{rds_password}\n{rds_endpoint}"
        # Inject the variables into the script
        #user_data = f"\nDBName={rds_dbname}\nDBUser={rds_username}\nDBPassword={rds_password}\nRDS_ENDPOINT={rds_endpoint}\n{userdata_script}"
        user_data = userdata_script.format(
            DBName=rds_dbname,
            DBUser=rds_username,
            DBPassword=rds_password,
            RDS_ENDPOINT=rds_endpoint,
        )
        #print(f"Userdata : {user_data}")
        # Create EC2 instance
        instance = self.ec2.create_instances(
            ImageId=ami_id,
            InstanceType=Variables.INSTANCE_TYPE,
            KeyName=Variables.KEY_NAME,
            UserData=user_data,
            MaxCount=1,
            MinCount=1,
            NetworkInterfaces=[
                {
                    "SubnetId": self.subnet_id,
                    "DeviceIndex": 0,
                    "AssociatePublicIpAddress": True,
                    "Groups": [self.security_group_id],
                }
            ],
            # SecurityGroupIds=[self.security_group_id],
            TagSpecifications=[
                {
                    "ResourceType": "instance",
                    "Tags": [{"Key": "Name", "Value": Variables.INSTANCE_TAG_NAME}],
                }
            ],
        )

        self.instance_id = instance[0].id
        self.public_ip_address = instance[0].public_ip_address
        # Print PublicIP address
        print("Public IP address:", self.public_ip_address)

        return self.instance_id
