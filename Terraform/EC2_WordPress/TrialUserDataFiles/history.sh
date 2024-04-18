sudo yum update -y
sudo yum uninstall httpd
yum --help
sudo systemctl start httpd
sudo systemctl enable httpd
sudo yum install -y mariadb-server
sudo yum install -y php php-cli php-pdo php-fpm php-json php-mysqlnd
sudo amazon-linux-extras install
sudo yum install -y php-cli php-pdo php-fpm php-json php-mysqlnd
sudo yum clean metadata
php --version
sudo yum update -y
php --version
clear
sudo systemctl status httpd
sudo systemctl status mariadb
sudo systemctl start mariadb
sudo systemctl status mariadb
sudo amazon-linux-extras install 
sudo amazon-linux-extras enable php7.4
yum clean metadata
sudo systemctl restart httpd
sudo systemctl enable mariadb
exit
DBRootPassword='rootpassword'
mysqladmin -u root password $DBRootPassword
sudo yum install -y wget
wget http://wordpress.org/latest.tar.gz -P /var/www/html
sudo wget http://wordpress.org/latest.tar.gz -P /var/www/html
cd /var/www/html
tar -zxvf latest.tar.gz
cp -rvf wordpress/* .
cp -rvf wordpress/* 
cp -rvf wordpress/* .
rm -R wordpress
tar -zxvf latest.tar.gz
sudo tar -zxvf latest.tar.gz
cp -rvf wordpress/* .
sudo cp -rvf wordpress/* .
sudo rm -R wordpress
rm latest.tar.gz
sudo rm latest.tar.gz
DBName='wordpress_db'
DBUser='wordpress_user'
DBPassword='wordpress_password'
sudo cp ./wp-config-sample.php ./wp-config.php
sudo sed -i "s/'database_name_here'/'$DBName'/g" wp-config.php
sudo sed -i "s/'username_here'/'$DBUser'/g" wp-config.php
sudo sed -i "s/'password_here'/'$DBPassword'/g" wp-config.php
sudo usermod -a -G apache ec2-user
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www
sudo find /var/www -type d -exec chmod 2775 {} \;
sudo find /var/www -type f -exec chmod 0664 {} \;
sudo echo "CREATE DATABASE $DBName;" >> /tmp/db.setup
sudo echo "CREATE USER '$DBUser'@'localhost' IDENTIFIED BY '$DBPassword';" >> /tmp/db.setup
sudo echo "GRANT ALL ON $DBName.* TO '$DBUser'@'localhost';" >> /tmp/db.setup
sudo echo "FLUSH PRIVILEGES;" >> /tmp/db.setup
sudo mysql -u root --password=$DBRootPassword < /tmp/db.setup
sudo sudo rm /tmp/db.setup
sudo yum install -y httpd
sudo systemctl restart httpd
sudo amazon-linux-extras enable php7.4
yum clean metadata
yum install php-cli php-pdo php-fpm php-json php-mysqlnd
sudo yum clean metadata
sudo yum install php-cli php-pdo php-fpm php-json php-mysqlnd
sudo systemctl restart httpd




#!/bin/bash
yum -y update
yum -y install httpd
cd /home/ec2-user
#wget https://aws-tc-largeobjects.s3.amazonaws.com/CUR-TF-100-RESTRT-1/29-lab-managing-services/init.sh
wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-100-RESTRT-1/266-lab-NF-troubleshooting-network-issue/s3/init.sh
chown ec2-user init.sh
chmod u+x init.sh
./init.sh
rm -f ./init.sh
chown -R ec2-user /home/ec2-user
    
