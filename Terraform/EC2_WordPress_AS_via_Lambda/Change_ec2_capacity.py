import boto3
import logging

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)


def increase_ec2_AS(event, context):
    try:
        logger.info("Lambda function execution started.")

        # Initialize Auto Scaling client
        autoscaling = boto3.client("autoscaling")

        # Describe Auto Scaling Groups
        response = autoscaling.describe_auto_scaling_groups()
        logger.info(f"Describing Auto Scaling Groups: {response}")

        # Iterate over Auto Scaling Groups
        for group in response["AutoScalingGroups"]:
            if group["AutoScalingGroupName"] == "wordpress-asg":
                # Retrieve the desired capacity and max size of the Auto Scaling Group
                desired_capacity = group["DesiredCapacity"]
                new_capacity = min(group["MaxSize"], desired_capacity + 1)

                # Update the Auto Scaling Group with the new desired capacity
                autoscaling.update_auto_scaling_group(
                    AutoScalingGroupName="wordpress-asg",
                    DesiredCapacity=new_capacity
                )
                logger.info(
                    f"Increased capacity of Auto Scaling Group {group['AutoScalingGroupName']} to {new_capacity}."
                )

        logger.info("Lambda function execution completed.")
        # Return a success message
        return {
            "statusCode": 200,
            "body": "Auto Scaling Group capacity increased successfully",
        }
    except Exception as e:
        # Log the error message
        logger.error(f"Error occurred: {str(e)}")
        # Return an error response with details
        return {
            "statusCode": 500,
            "body": f"Error occurred: {str(e)}"
        }

def decrease_ec2_AS(event, context):
    try:
        logger.info("Lambda function execution started.")

        # Initialize Auto Scaling client
        autoscaling = boto3.client("autoscaling")

        # Describe Auto Scaling Groups
        response = autoscaling.describe_auto_scaling_groups()
        logger.info(f"Describing Auto Scaling Groups: {response}")

        # Iterate over Auto Scaling Groups
        for group in response["AutoScalingGroups"]:
            if group["AutoScalingGroupName"] == "wordpress-asg":
                # Retrieve the desired capacity and max size of the Auto Scaling Group
                desired_capacity = group["DesiredCapacity"]
                new_capacity = max(group["MinSize"], desired_capacity - 1)

                # Update the Auto Scaling Group with the new desired capacity
                autoscaling.update_auto_scaling_group(
                    AutoScalingGroupName="wordpress-asg",
                    DesiredCapacity=new_capacity
                )
                logger.info(
                    f"Increased capacity of Auto Scaling Group {group['AutoScalingGroupName']} to {new_capacity}."
                )

        logger.info("Lambda function execution completed.")
        # Return a success message
        return {
            "statusCode": 200,
            "body": "Auto Scaling Group capacity increased successfully",
        }
    except Exception as e:
        # Log the error message
        logger.error(f"Error occurred: {str(e)}")
        # Return an error response with details
        return {
            "statusCode": 500,
            "body": f"Error occurred: {str(e)}"
        }
