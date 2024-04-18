import json
import logging
import os
import boto3

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    logger.info("Received event: " + json.dumps(event))
    try:
        if "Records" in event:
            # Extract message details from the SNS event
            sns_message = json.loads(event["Records"][0]["Sns"]["Message"])
            subject = sns_message.get("Subject", "No subject")
            body = sns_message.get("Message", "No message")

            # Customize email subject and body
            custom_subject = os.environ["EMAIL_SUBJECT"]
            custom_body = os.environ["EMAIL_BODY"]

            # Send email using AWS SES
            ses = boto3.client(
                "ses", region_name="us-west-2"
            )  # Change region if necessary
            response = ses.send_email(
                Source="managementTeam@aws.com",  # Change sender email address
                Destination={
                    "ToAddresses": [
                        ""
                    ]  # Change recipient email address
                },
                Message={
                    "Subject": {"Data": custom_subject},
                    "Body": {"Text": {"Data": custom_body}},
                },
            )
            return {"statusCode": 200, "body": json.dumps("Email sent successfully!")}
        else:
            return {
                "statusCode": 400,
                "body": json.dumps('Invalid event format: Missing "Records" key'),
            }
    except KeyError as e:
        # Handle KeyError
        return {"statusCode": 400, "body": json.dumps(f"KeyError: {str(e)}")}
    except Exception as e:
        # Handle other exceptions
        return {"statusCode": 500, "body": json.dumps(f"Error: {str(e)}")}
