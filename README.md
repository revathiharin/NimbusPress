# NimbusPress
 This contains the final capstone project and presentaion in the main branch and series of smaller projects that demonstrate individual implementaions of various components using Terraform and Python in other branches.

## Resilient and Scalable WordPress Solution

![Architecture](.\Terraform\Pictures\Architecture.png)
### Overview
This project aims to create a resilient and scalable WordPress solution on AWS by utilizing Terraform for infrastructure provisioning and Python for additional automation. The solution includes EC2 instances, an Application Load Balancer (ALB), an Auto Scaling Group (ASG), and Amazon Relational Database Service (RDS) to ensure high availability, scalability, and efficient resource management.

[Presentation](.\Terraform\Presentation\TerraformProject.pdf)

### Project Setup
- WordPress is set up with RDS MySQL as the database.
- PHP version used is greater than 7.4.

#### Setup Components
- **1 VPC**: 
  - Includes 2 Public subnets and 2 Private subnets.
  - 1 Internet Gateway (IGW) attached.
  - Separate route tables for public and private subnets.
- **Security Group**:
  - Allows HTTP and SSH traffic.
- **EC2 Instance**:
  - Configured with Apache, PHP, and WordPress.
  - Points to RDS database for data storage.
- **ELB as Application Load Balancer**:
  - Includes Target Group and Listener configurations.
- **Auto Scaling**:
  - Configured with minimum 1, desired 2, and maximum 4 instances.
- **Userdata**:
  - EC2 instances and AS instances use the same userdata.
  - Downloads and configures WordPress each time an EC2 instance is launched.

### Setup
#### Terraform
1. Install Terraform from [Terraform's official website](https://www.terraform.io/downloads.html).
2. Clone this repository to your local machine.
3. Navigate to the cloned directory.
4. Initialize Terraform by running `terraform init`.
5. Review and modify the `terraform.tfvars` file to set your AWS credentials and desired configuration parameters.
6. Apply the Terraform configuration by running `terraform apply`.
7. After successful provisioning, Terraform will output the necessary information, including the ALB URL, ASG details, and RDS connection information.

#### Python
1. Ensure Python 3 is installed on your system.
2. Install the required Python dependencies using `pip install -r requirements.txt`.
3. Modify the `config.py` file to include your AWS credentials.
4. Run the Python scripts to perform additional automation tasks or customizations as needed.

### Keyname Change
To change the EC2 instance keypair (keyname), follow these steps:
1. Update the `key_name` variable in the `vars.tf` file with the desired keypair name.
2. Reapply the Terraform configuration by running `terraform apply`.

### Labrole Change
To change the IAM role used by EC2 instances, follow these steps:
1. Update the `instance_profile` variable in the `vars.tf` file with the ARN of the desired IAM role.
2. Reapply the Terraform configuration by running `terraform apply`.

### Additional Notes
- For security purposes, ensure that your AWS credentials are securely stored and never committed to version control.
- Regularly monitor the resources created by this solution to optimize costs and performance.
- Consider implementing backup and disaster recovery mechanisms for the RDS instance to enhance data resilience.
