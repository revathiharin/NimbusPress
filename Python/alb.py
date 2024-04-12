import boto3

class ALB:
    def __init__(self):
        self.elbv2 = boto3.client("elbv2")

    def create_load_balancer(self, subnet_ids, security_group_id):
        # Hardcoded values
        alb_name = "alb"
        
        alb_scheme = "internet-facing"

        # Create Application Load Balancer
        alb = self.elbv2.create_load_balancer(
            Name=alb_name,
            Subnets=subnet_ids,
            SecurityGroups=[security_group_id],
            Scheme=alb_scheme,
            Tags=[
                {
                    'Key': 'Name',
                    'Value': alb_name
                },
            ]
        )
        print("ALB created:", alb)


        return alb["LoadBalancers"][0]["LoadBalancerArn"]
