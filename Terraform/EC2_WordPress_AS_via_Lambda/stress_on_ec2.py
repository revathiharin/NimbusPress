import boto3
import logging

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):
    try:
        logger.info("Lambda function execution started.")

        # Initialize EC2 client
        ec2 = boto3.client("ec2")

        # Retrieve the EC2 instance ID by its name
        instance_name = "your-instance-name"  # Replace with your EC2 instance name
        response = ec2.describe_instances(Filters=[{"Name": "tag:Name", "Values": [instance_name]}])

        # Extract the instance ID
        instance_id = response["Reservations"][0]["Instances"][0]["InstanceId"]

        # Put stress on the EC2 instance (example: by executing a stress test command)
        # For example, you can use the 'stress' command to simulate CPU stress
        # You may need to install the 'stress' package on the EC2 instance
        # You can also use other stress-testing tools depending on your requirements
        # Here, we are just logging the action for demonstration purposes
        logger.info(f"Putting stress on EC2 instance with ID: {instance_id}")

        # Execute stress test command (replace with your actual stress-testing command)
        # Example: ec2.run_instances(InstanceId=instance_id, UserData="stress --cpu 4")
        ec2.run_instances(InstanceId=instance_id, UserData="stress-ng --cpu 4 --timeout 300s")
        
        # Simulate stress by logging a message
        logger.info("Stress applied successfully.")

        logger.info("Lambda function execution completed.")
        # Return a success message
        return {
            "statusCode": 200,
            "body": "Stress applied successfully to the EC2 instance",
        }
    except Exception as e:
        # Log the error message
        logger.error(f"Error occurred: {str(e)}")
        # Return an error response with details
        return {
            "statusCode": 500,
            "body": f"Error occurred: {str(e)}"
        }
