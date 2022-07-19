#!/bin/bash
source components/common.sh
COMPONENT=mysqldb
LOGFILE="/tmp/$COMPONENT.log"
mysqlRepo="https://raw.githubusercontent.com/stans-robot-project/mysql/main/mysql.repo"
sw=nginx

set -e
echo -e "\e[32m hello I'm mysql \e[0m"

curl -s -L -o /etc/yum.repos.d/mysql.repo mysqlRepo
yum install mysql-community-server -y
systemctl enable mysqld 
systemctl start mysqld
grep temp /var/log/mysqld.log



# mysql_secure_installation

#mysql -uroot -pRoboShop@1
#uninstall plugin validate_password;