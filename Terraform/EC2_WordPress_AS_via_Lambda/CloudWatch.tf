# Create CloudWatch alarms
# Create CloudWatch alarm for increasing capacity
resource "aws_cloudwatch_metric_alarm" "increase_cpu_utilization_alarm" {
  alarm_name          = "increase_cpu_utilization_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Alarm when CPU utilization is greater than or equal to 70%"
  alarm_actions       = [aws_lambda_function.increase_ec2_capacity.arn]
}

# Create CloudWatch alarm for decreasing capacity
resource "aws_cloudwatch_metric_alarm" "decrease_cpu_utilization_alarm" {
  alarm_name          = "decrease_cpu_utilization_alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 30  # Adjust this threshold as needed for decreasing capacity
  alarm_description   = "Alarm when CPU utilization is less than or equal to 30%"
  alarm_actions       = [aws_lambda_function.decrease_ec2_capacity.arn]
}


# Add CloudWatch logs for Lambda function
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/Change_ec2_capacity"
  retention_in_days = 14
}

# Create CloudWatch log stream
resource "aws_cloudwatch_log_stream" "lambda_log_stream" {
  name           = "Change_ec2_capacity"
  log_group_name = aws_cloudwatch_log_group.lambda_log_group.name
}

/*
# CloudWatch IAM policy for Lambda
data "aws_iam_policy_document" "cloudwatch_lambda_policy" {
  statement {
    actions   = ["logs:CreateLogStream", "logs:CreateLogGroup", "logs:PutLogEvents"]
    resources = [aws_cloudwatch_log_group.lambda_log_group.arn, aws_cloudwatch_log_stream.lambda_log_stream.arn]
  }
}

# CloudWatch IAM policy attachment for Lambda
resource "aws_iam_policy" "cloudwatch_lambda_policy" {
  name        = "cloudwatch_lambda_policy"
  policy      = data.aws_iam_policy_document.cloudwatch_lambda_policy.json
}

resource "aws_iam_role_policy_attachment" "cloudwatch_lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.cloudwatch_lambda_policy.arn
}
*/

/*
# Create CloudWatch alarm for decreasing capacity
resource "aws_cloudwatch_metric_alarm" "cpu_utilization_alarm" {
  alarm_name          = "stress_on_ec2"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80  # Adjust this threshold as needed for decreasing capacity
  alarm_description   = "Alarm when CPU utilization is less than or equal to 80%"
  alarm_actions       = [aws_sns_topic.sns_topic.arn]
  dimensions = {
    InstanceId = aws_instance.wordpress_instance.id
  }
}

/* 
# Add CloudWatch logs for Lambda function
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/stress_on_ec2"
  retention_in_days = 14
}

# Create CloudWatch log stream sns
resource "aws_cloudwatch_log_stream" "lambda_log_stream" {
  name           = "stress_on_ec2"
  log_group_name = aws_cloudwatch_log_group.lambda_log_group.name
} */


/*
# CloudWatch IAM policy for Lambda
data "aws_iam_policy_document" "cloudwatch_lambda_policy" {
  statement {
    actions   = ["logs:CreateLogStream", "logs:CreateLogGroup", "logs:PutLogEvents"]
    resources = [aws_cloudwatch_log_group.lambda_log_group.arn, aws_cloudwatch_log_stream.lambda_log_stream.arn]
  }
}

# CloudWatch IAM policy attachment for Lambda
resource "aws_iam_policy" "cloudwatch_lambda_policy" {
  name        = "cloudwatch_lambda_policy"
  policy      = data.aws_iam_policy_document.cloudwatch_lambda_policy.json
}

resource "aws_iam_role_policy_attachment" "cloudwatch_lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.cloudwatch_lambda_policy.arn
}
*/
