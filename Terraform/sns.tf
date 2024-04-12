# SNS Topic
resource "aws_sns_topic" "sns_topic" {
  name = "sns_topic"
}

# SNS Subscription for Email
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn              = aws_sns_topic.sns_topic.arn
  protocol               = "email"
  endpoint               = "saregameacc1@gmail.com"
  endpoint_auto_confirms = true

}

