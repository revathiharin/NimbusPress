#!/bin/bash

# Install Apache server
sudo yum install -y httpd

# Start Apache server and enable it on system startup
sudo systemctl start httpd
sudo systemctl enable httpd

# Install MariaDB
sudo yum install -y mariadb-server 

# Install PHP (version 7.4)
sudo yum install -y php 
sudo amazon-linux-extras install 
sudo yum clean metadata
sudo yum install -y php-cli php-pdo php-fpm php-json php-mysqlnd

:'
# Install PHP My-SQL
sudo yum install -y php-mysqlnd

# Install PHP admin
sudo yum install -y php-mbstring php-xml

# Install required dependencies for PHPAdmin
sudo yum install php-mbstring php-xml -y

# Enable PHP version 7.4
sudo amazon-linux-extras enable php7.4

# Clean YUM metadata for updated package info.
sudo yum clean metadata

# Restart Apache
sudo systemctl restart httpd

# Start MariaDB service and enable it on system startup
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Set MariaDB root password
DBRootPassword='rootpassword'
mysqladmin -u root password $DBRootPassword

# Download and install WordPress
sudo yum install -y wget
wget http://wordpress.org/latest.tar.gz -P /var/www/html
cd /var/www/html
tar -zxvf latest.tar.gz
cp -rvf wordpress/* .
rm -R wordpress
rm latest.tar.gz

# Configure WordPress
DBName='wordpress_db'
DBUser='wordpress_user'
DBPassword='wordpress_password'

# Making changes to the wp-config.php file, setting the DB name
cp ./wp-config-sample.php ./wp-config.php
sed -i "s/'database_name_here'/'$DBName'/g" wp-config.php
sed -i "s/'username_here'/'$DBUser'/g" wp-config.php
sed -i "s/'password_here'/'$DBPassword'/g" wp-config.php

# Grant permissions
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;

# Create WordPress database
echo "CREATE DATABASE $DBName;" >> /tmp/db.setup
echo "CREATE USER '$DBUser'@'localhost' IDENTIFIED BY '$DBPassword';" >> /tmp/db.setup
echo "GRANT ALL ON $DBName.* TO '$DBUser'@'localhost';" >> /tmp/db.setup
echo "FLUSH PRIVILEGES;" >> /tmp/db.setup
mysql -u root --password=$DBRootPassword < /tmp/db.setup
sudo rm /tmp/db.setup

'
