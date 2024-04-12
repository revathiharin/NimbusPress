import boto3

class VPC:
    def __init__(self):
        self.ec2 = boto3.client("ec2")
        self.vpc_id = None
        self.public_subnet_ids = []
        self.private_subnet_ids = []
        self.route_table_id = None

    def create_vpc(self):
        # Create VPC with CIDR block 10.0.0.0/16
        vpc = self.ec2.create_vpc(CidrBlock="10.0.0.0/16")
        self.vpc_id = vpc["Vpc"]["VpcId"]
        self.ec2.create_tags(
            Resources=[self.vpc_id],
            Tags=[{"Key": "Name", "Value": "VPC"}],
        )
        self.ec2.modify_vpc_attribute(
            VpcId=self.vpc_id, EnableDnsSupport={"Value": True}
        )
        self.ec2.modify_vpc_attribute(
            VpcId=self.vpc_id, EnableDnsHostnames={"Value": True}
        )
        print(f"VPC created with ID: {self.vpc_id}")
        print(f"DNS support enabled for VPC: {self.vpc_id}")
        print(f"DNS hostnames enabled for VPC: {self.vpc_id}")
        

        # Create internet gateway
        igw = self.ec2.create_internet_gateway()
        igw_id = igw["InternetGateway"]["InternetGatewayId"]
        self.ec2.create_tags(
            Resources=[igw_id],
            Tags=[{"Key": "Name", "Value": "InternetGateway"}],
        )
        print(f"Internet gateway created with ID: {igw_id}")

        # Attach internet gateway to VPC
        self.ec2.attach_internet_gateway(InternetGatewayId=igw_id, VpcId=self.vpc_id)

        # Create route table
        route_table = self.ec2.create_route_table(VpcId=self.vpc_id)
        self.route_table_id = route_table["RouteTable"]["RouteTableId"]
        self.ec2.create_tags(
            Resources=[self.route_table_id],
            Tags=[{"Key": "Name", "Value": "RouteTable"}],
        )
        print(f"Route table created with ID: {self.route_table_id}")
        subnet_numbering = 0
        # Create subnets
        availability_zones = ["us-west-2a", "us-west-2b"]
        for i, az in enumerate(availability_zones):
            subnet_numbering += 1
            subnet_cidr = f"10.0.{subnet_numbering}.0/24"
            
            # Create public subnet
            public_subnet = self.ec2.create_subnet(
                VpcId=self.vpc_id, CidrBlock=subnet_cidr, AvailabilityZone=az
            )
            public_subnet_id = public_subnet["Subnet"]["SubnetId"]
            self.public_subnet_ids.append(public_subnet_id)
            self.ec2.create_tags(
                Resources=[public_subnet_id],
                Tags=[{"Key": "Name", "Value": f"PublicSubnet{i+1}"}],
            )
            print(f"Public subnet {i+1} created with ID: {public_subnet_id}")
        
            # Associate public subnet with route table
            self.ec2.associate_route_table(
                RouteTableId=self.route_table_id, SubnetId=public_subnet_id
            )

        for i, az in enumerate(availability_zones):
            subnet_numbering += 1
            subnet_cidr = f"10.0.{subnet_numbering}.0/24"
            # Create private subnet
            private_subnet = self.ec2.create_subnet(
                VpcId=self.vpc_id, CidrBlock=subnet_cidr, AvailabilityZone=az
            )
            private_subnet_id = private_subnet["Subnet"]["SubnetId"]
            self.private_subnet_ids.append(private_subnet_id)
            self.ec2.create_tags(
                Resources=[private_subnet_id],
                Tags=[{"Key": "Name", "Value": f"PrivateSubnet{i+1}"}],
            )
            print(f"Private subnet {i+1} created with ID: {private_subnet_id}")

            # Associate private subnet with route table
            self.ec2.associate_route_table(
                RouteTableId=self.route_table_id, SubnetId=private_subnet_id
            )

        # Create route for internet traffic
        self.ec2.create_route(
            RouteTableId=self.route_table_id,
            DestinationCidrBlock="0.0.0.0/0",
            GatewayId=igw_id,
        )

        return (
            self.vpc_id,
            self.public_subnet_ids,
            self.private_subnet_ids,
            self.route_table_id,
        )
