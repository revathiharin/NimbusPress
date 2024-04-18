/* #Create a s3 Bucket with Wordpress into it s3-bucket-2024-03-22-2973
resource "aws_s3_bucket" "wordpress" {
    bucket = "${var.s3_bucket_name}-${var.tagNameDate}-2973"
    #object_lock_enabled = false
    tags = {
        Name = "${var.s3_bucket_name}_${var.tagNameDate}"
    }
    # Ignore changes to s3 bucket resource
    lifecycle {
        ignore_changes = [bucket]
    }
}
 */



   
