#! /bin/bash
# # Install updates
sudo yum update -y

#Install httpd
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd

#Install MariaDB
sudo yum install -y mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb

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

sudo yum install -y wget
sudo wget http://wordpress.org/latest.tar.gz -P /var/www/html

cd /var/www/html
sudo tar -zxvf latest.tar.gz
sudo cp -rvf wordpress/* .

sudo rm -R wordpress
sudo rm latest.tar.gz

#Configure Wordpress
DBName='wordpress_db'
DBUser='wordpress_user'
DBPassword='wordpress_password'

# Copy wp-config.php file to wordpress directory
sudo cp ./wp-config-sample.php ./wp-config.php
sudo sed -i "s/'database_name_here'/'$DBName'/g" wp-config.php
sudo sed -i "s/'username_here'/'$DBUser'/g" wp-config.php
sudo sed -i "s/'password_here'/'$DBPassword'/g" wp-config.php

# Create wordpress database
sudo usermod -a -G apache ec2-user
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www
sudo find /var/www -type d -exec chmod 2775 {} \;
sudo find /var/www -type f -exec chmod 0664 {} \;

# Create database and user
sudo echo "CREATE DATABASE $DBName;" >> /tmp/db.setup
sudo echo "CREATE USER '$DBUser'@'localhost' IDENTIFIED BY '$DBPassword';" >> /tmp/db.setup
sudo echo "GRANT ALL ON $DBName.* TO '$DBUser'@'localhost';" >> /tmp/db.setup
sudo echo "FLUSH PRIVILEGES;" >> /tmp/db.setup
sudo mysql -u root --password=$DBRootPassword < /tmp/db.setup

# Cleanup
sudo rm /tmp/db.setup


#Install PHP Extensions
sudo amazon-linux-extras enable php7.4
sudo yum clean metadata
sudo yum install -y php-cli php-pdo php-fpm php-json php-mysqlnd


# Restart Apache
sudo systemctl restart httpd
