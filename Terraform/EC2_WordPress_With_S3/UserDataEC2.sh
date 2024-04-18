#! /bin/bash
# # Install updates
sudo yum update -y

# Configure AWS CLI with IAM role credentials
aws configure set default.region us-west-2

#Install httpd
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd

#Install MariaDB
#sudo yum install -y mariadb-server
#sudo systemctl start mariadb
#sudo systemctl enable mariadb

#Install mysql
sudo yum install -y mysql
#sudo systemctl start mysql
#sudo systemctl enable mysql
#sudo mysql_secure_installation

#Install PHP
sudo yum install -y php 
sudo amazon-linux-extras install 
#sudo yum install -y php-cli php-pdo php-fpm php-json php-mysqlnd
#sudo yum clean metadata

# Update all installed 
sudo yum update -y

#Restart Apache
sudo systemctl restart httpd

#Install Wordpress
DBRootPassword='rootpassword'
mysqladmin -u root password $DBRootPassword

# Retrieve RDS endpoint from Terraform output
#RDS_ENDPOINT=$(terraform output -json rds_endpoint | jq -r '.value')
DBName=${rds_db_name}
DBUser=${rds_username}
DBPassword=${rds_password}
RDS_ENDPOINT=${rds_endpoint}
S3_BucketName=${s3_bucket_name}


# Create a temporary file to store the database value
sudo touch db.txt
sudo chmod 777 db.txt
sudo echo "DATABASE $DBName;" >> db.txt
sudo echo "USER $DBUser;" >> db.txt
sudo echo "PASSWORD $DBPassword;" >> db.txt
sudo echo "HOST $RDS_ENDPOINT;" >> db.txt


sudo yum install -y wget
sudo wget http://wordpress.org/latest.tar.gz -P /var/www/html/

#aws s3 cp s3://$S3_BucketName/latest.tar.gz /var/www/html/latest.tar.gz

cd /var/www/html
sudo tar -zxvf latest.tar.gz
cd wordpress/
#sudo cp -rvf wordpress/* .

#sudo rm -R wordpress
#sudo rm latest.tar.gz

echo "Terraform output:"


# Copy wp-config.php file to wordpress directory
sudo cp ./wp-config-sample.php ./wp-config.php
sudo sed -i "s/'database_name_here'/'$DBName'/g" wp-config.php
sudo sed -i "s/'username_here'/'$DBUser'/g" wp-config.php
sudo sed -i "s/'password_here'/'$DBPassword'/g" wp-config.php
sudo sed -i "s/'localhost'/'$RDS_ENDPOINT'/g" wp-config.php

cd /var/www/html
#Zip all files in wordpress directory to wordpress.tar.gz
sudo tar -zcvf wordpress.tar.gz wordpress

#Upload wordpress.tar.gz to s3 Bucket
aws s3 cp ./wordpress.tar.gz s3://$S3_BucketName/wordpress.tar.gz 

echo "Wordpress upload complete."

# Remove wordpress.tar-gz
sudo rm wordpress.tar.gz
sudo rm -R wordpress
sudo rm latest.tar.gz

# Create wordpress database
# sudo usermod -a -G apache ec2-user
# sudo chown -R ec2-user:apache /var/www
# sudo chmod 2775 /var/www
# sudo find /var/www -type d -exec chmod 2775 {} \;
# sudo find /var/www -type f -exec chmod 0664 {} \;

# Create database and user
#sudo echo "CREATE DATABASE $DBName;" >> /tmp/db.setup
#sudo echo "CREATE USER '$DBUser'@'localhost' IDENTIFIED BY '$DBPassword';" >> /tmp/db.setup
#sudo echo "GRANT ALL ON $DBName.* TO '$DBUser'@'localhost';" >> /tmp/db.setup
#sudo echo "FLUSH PRIVILEGES;" >> /tmp/db.setup
#sudo mysql -u root --password=$DBRootPassword < /tmp/db.setup
# Replace "<DB_USERNAME>", "<DB_PASSWORD>", and "<DB_NAME>" with your actual values
#mysql -h "$RDS_ENDPOINT" -u "<DB_USERNAME>" -p"<DB_PASSWORD>" "<DB_NAME>" -e "SELECT * FROM your_table;"

sudo mysql -h "$RDS_ENDPOINT" -u "$DBUser" -p"$DBPassword" "$DBName" -e "SHOW DATABASES;"

#sudo mysql -h "rds-db-2024-03-11.cl6aouewg3un.us-west-2.rds.amazonaws.com" -u "admin" -p"admin123" "wordpressDb" -e "SHOW DATABASES;"


# Cleanup
#sudo rm /tmp/db.setup


#Install PHP Extensions
sudo amazon-linux-extras enable php7.4
sudo yum clean metadata
sudo yum install -y php-cli php-pdo php-fpm php-json php-mysqlnd


# Restart Apache
sudo systemctl restart httpd

# #!/bin/bash

# # Retrieve AWS temporary credentials from instance metadata
# export AWS_ACCESS_KEY_ID=$(curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/YourRoleName | jq -r .AccessKeyId)
# export AWS_SECRET_ACCESS_KEY=$(curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/YourRoleName | jq -r .SecretAccessKey)
# export AWS_SESSION_TOKEN=$(curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/YourRoleName | jq -r .Token)

# # Use AWS CLI or SDK with the retrieved credentials
# aws s3 cp s3://your-bucket/your-file.txt /path/to/local/file

echo "Userdata execution completed" >> /var/log/userdata.log
