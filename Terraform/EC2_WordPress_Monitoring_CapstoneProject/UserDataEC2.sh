#! /bin/bash
# # Install updates
sudo yum update -y

# Configure AWS CLI with IAM role credentials
aws configure set default.region us-west-2

sudo yum install -y stress-ng

#Install httpd
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd

#Install mysql
sudo yum install -y mysql

#Install PHP
sudo yum install -y php 
sudo amazon-linux-extras install 


# Update all installed 
sudo yum update -y

#Restart Apache
sudo systemctl restart httpd

#Install Wordpress
DBRootPassword='rootpassword'
mysqladmin -u root password $DBRootPassword

# Retrieve RDS endpoint from Terraform output
DBName=${rds_db_name}
DBUser=${rds_username}
DBPassword=${rds_password}
RDS_ENDPOINT=${rds_endpoint}

# Create a temporary file to store the database value
sudo touch db.txt
sudo chmod 777 db.txt
sudo echo "DATABASE $DBName;" >> db.txt
sudo echo "USER $DBUser;" >> db.txt
sudo echo "PASSWORD $DBPassword;" >> db.txt
sudo echo "HOST $RDS_ENDPOINT;" >> db.txt


sudo yum install -y wget
sudo wget http://wordpress.org/latest.tar.gz -P /var/www/html/

cd /var/www/html
sudo tar -zxvf latest.tar.gz
sudo cp -rvf wordpress/* .

sudo rm -R wordpress
sudo rm latest.tar.gz

echo "Terraform output:"

# Copy wp-config.php file to wordpress directory
sudo cp ./wp-config-sample.php ./wp-config.php
sudo sed -i "s/'database_name_here'/'$DBName'/g" wp-config.php
sudo sed -i "s/'username_here'/'$DBUser'/g" wp-config.php
sudo sed -i "s/'password_here'/'$DBPassword'/g" wp-config.php
sudo sed -i "s/'localhost'/'$RDS_ENDPOINT'/g" wp-config.php

sudo mysql -h "$RDS_ENDPOINT" -u "$DBUser" -p"$DBPassword" "$DBName" -e "SHOW DATABASES;"

#Install PHP Extensions
sudo amazon-linux-extras enable php7.4
sudo yum clean metadata
sudo yum install -y php-cli php-pdo php-fpm php-json php-mysqlnd

# Restart Apache
sudo systemctl restart httpd
