import boto3

class SecurityGroup:
    def __init__(self, vpc_id):
        self.ec2 = boto3.client("ec2")
        self.vpc_id = vpc_id

    def create_security_group(self, group_name, description, ingress_rules):
        # Create security group
        security_group = self.ec2.create_security_group(
            GroupName=group_name,
            Description=description,
            VpcId=self.vpc_id
        )

        security_group_id = security_group["GroupId"]
        print(f"Security group created with ID: {security_group_id}")

        # Authorize ingress rules
        for rule in ingress_rules:
            self.ec2.authorize_security_group_ingress(
                GroupId=security_group_id,
                IpProtocol=rule["IpProtocol"],
                FromPort=rule["FromPort"],
                ToPort=rule["ToPort"],
                CidrIp=rule["CidrIp"]
            )

        return security_group_id
