#! /bin/bash
# # Install updates
sudo yum update -y

# Update packages and install necessary software
sudo yum install -y httpd mariadb-server php php-mysqlnd
sudo yum update -y httpd mariadb-server php php-mysqlnd

# Start and enable Apache (httpd) and MariaDB services
sudo systemctl start httpd
sudo systemctl enable httpd

sudo systemctl start mariadb
sudo systemctl enable mariadb

# Download and install Wordpress
sudo wget http://wordpress.org/latest.tar.gz -P /var/www/html
cd /var/www/html
tar -zxvf latest.tar.gz 
cp -rvf wordpress/* . 


# Set database variables
DB_NAME='wordpress'
DB_USER='user_2024_02_23'
DB_PASS='XXXX_2024_02_23'
DB_Root_Password='admin'

# Set Mariadb root password
sudo mysqladmin -u root password $DB_Root_Password

# Configure Wordpress

# Making changes to the wp-config.php file, setting the DB name
sudo cp ./wp-config-sample.php ./wp-config.php # rename the file from sample to clean
sudo sed -i "s/'database_name_here'/'$DBName'/g" wp-config.php 
sudo sed -i "s/'username_here'/'$DBUser'/g" wp-config.php 
sudo sed -i "s/'password_here'/'$DBPassword'/g" wp-config.php
# Grant permissions
