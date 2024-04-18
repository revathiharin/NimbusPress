# Create Lambda deployment package
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/Change_ec2_capacity.zip"
  source {
    content  = file("${path.module}/Change_ec2_capacity.py")
    filename = "Change_ec2_capacity.py"
  }

}

# Create Lambda function for stress creation in EC2
resource "aws_lambda_function" "increase_ec2_capacity" {
  filename      = data.archive_file.lambda_zip.output_path
  function_name = "increase_ec2_capacity"
  role          = var.LabRoleARN
  handler       = "Change_ec2_capacity.increase_ec2_AS"
  runtime       = "python3.8"

  # Ensure Lambda function waits for the zip file to be created
  depends_on = [data.archive_file.lambda_zip]
}
# Create Lambda function for stress creation in EC2
resource "aws_lambda_function" "decrease_ec2_capacity" {
  filename      = data.archive_file.lambda_zip.output_path
  function_name = "decrease_ec2_capacity"
  role          = var.LabRoleARN
  handler       = "Change_ec2_capacity.decrease_ec2_AS"
  runtime       = "python3.8"

  # Ensure Lambda function waits for the zip file to be created
  depends_on = [data.archive_file.lambda_zip]
}
/*
# Add Invoke Event to the Lambda function
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.increase_ec2_capacity.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.increase_ec2_capacity.arn
}
# Create CloudWatch event rule for every 30 minute
resource "aws_cloudwatch_event_rule" "increase_ec2_capacity" {
  name                = "increase_ec2_capacity"
  description         = "Increase EC2 capacity every 30 minutes"
  schedule_expression = "rate(30 minutes)"
}*/


/* 

# Lambda IAM role
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Create Lambda deployment package
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/increase_ec2_capacity.zip"
  source {
    content  = <<-EOF
      import boto3
      
      def lambda_handler(event, context):
          ec2 = boto3.client('ec2')
          response = ec2.describe_auto_scaling_groups()
          
          for group in response['AutoScalingGroups']:
              if group['AutoScalingGroupName'] == 'wordpress-asg':
                  desired_capacity = group['DesiredCapacity']
                  new_capacity = min(group['MaxSize'], desired_capacity + 1)
                  ec2.update_auto_scaling_group(AutoScalingGroupName='wordpress-asg', DesiredCapacity=new_capacity)
    EOF
    filename = "increase_ec2_capacity.py"
  }
} 
# Create Lambda deployment package
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/CustomEmail.zip"
  source {
    content  = file("${path.module}/CustomEmail.py")
    filename = "CustomEmail.py"
  }

}


# Lambda Function
resource "aws_lambda_function" "send_email_function" {
  function_name = "send_email_function"
  handler       = "CustomEmail.lambda_handler"
  runtime       = "python3.8"
  filename      = data.archive_file.lambda_zip.output_path
  role          = var.LabRoleARN
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      EMAIL_SUBJECT = "Alert: CPU Utilization Reached 80%"
      EMAIL_BODY    = "The CPU utilization on your system has reached 80%. Please take necessary actions to optimize resource usage."

    }
  }

  # Ensure Lambda function waits for the zip file to be created
  depends_on = [data.archive_file.lambda_zip]
}
resource "aws_lambda_permission" "sns_invoke_permission" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sns_message_handler.function_name
  principal     = "sns.amazonaws.com"

  source_arn = aws_sns_topic.sns_topic.arn
}

*/
