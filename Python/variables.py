# variables.py


class Variables:
    # VPC Related Variables
    VPC_CIDR_BLOCK = "10.0.0.0/16"
    # Tag Name
    VPC_TAG_NAME = "VPC_WP"

    # Subnet Related Variables
    PUBLIC_SUBNET_TAG_NAME = "PublicSubnet_WP"
    PRIVATE_SUBNET_TAG_NAME = "PrivateSubnet_WP"
    PUBLIC_SUBNET_CIDR_BLOCK = "10.0.1.0/24"
    PRIVATE_SUBNET_CIDR_BLOCK = "10.0.2.0/24"
    DEFAULT_CIDR_BLOCK = ["0.0.0.0/0"]

    # Route Table Related Variables
    ROUTE_TABLE_TAG_NAME = "RouteTable_WP"

    # Internet Gateway Related Variables
    INTERNET_GATEWAY_TAG_NAME = "InternetGateway_WP"

    # Security Group Related Variables
    SECURITY_GROUP_TAG_NAME = "sg_SSH_HTTP"
    SECURITY_GROUP_DESCRIPTION = "Allow SSH and HTTP"
    SSH_PORT = 22
    HTTP_PORT = 80

    # EC2 Related Variables
    INSTANCE_TAG_NAME = "WordPress_Instance"
    AMI_OWNER_ID = "amazon"
    AMI_NAME = "amzn2-ami-hvm-2.0.20200304.1-x86_64-gp2"
    AMI_ID = "ami-0d442a425e2e0a743"
    INSTANCE_TYPE = "t2.micro"
    KEY_NAME = "vockey"
    USER_DATA_SCRIPT_PATH = "user_data_script.sh"
