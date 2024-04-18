 #Create a s3 Bucket with Wordpress into it s3-bucket-2024-03-22-2973
/* resource "aws_s3_bucket" "wordpress" {
    #bucket = "${var.s3_bucket_name}-${var.tagNameDate}-${random_integer.bucket_suffix.result}"
    bucket = "${var.s3_bucket_name}-${var.tagNameDate}-2973"
    #Disble object lock cong    
    #object_lock_enabled = false
    lifecycle {
        ignore_changes = [
            object_lock_configuration,  # This line tells Terraform to ignore changes to the Object Lock configuration
        ]
    }

    tags = {
        Name = "${var.s3_bucket_name}_${var.tagNameDate}"
    }
}  */
  
