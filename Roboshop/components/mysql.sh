#!/bin/bash
source components/common.sh
COMPONENT=mysql
LOGFILE="/tmp/$COMPONENT.log"
mysqlRepo="https://raw.githubusercontent.com/stans-robot-project/mysql/main/mysql.repo"

set -e
echo -e "\e[32m hello I'm mysql \e[0m"

echo -n "Download sw from repo"
curl -s -L -o /etc/yum.repos.d/mysql.repo $mysqlRepo
yum install mysql-community-server -y
stat $?

echo -n "Enable mysql service"
systemctl enable mysqld 
systemctl start mysqld
stat $?

echo "Check if it is first time login and change mysql root password if it is"
echo "show databases" | mysql -uroot -pRoboShop@1
if [ $? -ne 0 ]; then
    # Get default password and change password fo mysql
    echo -n "Change expired password"
    DEFAULT_PASSWORD=$(sudo grep "temporary password" /var/log/mysqld.log | awk '{print$NF}')
    echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('RoboShop@1');" > /tmp/changePassword.sql
    mysql --connect-expired-password -uroot -p"$DEFAULT_PASSWORD" < /tmp/changePassword.sql
    stat $?
fi

echo "Check if it is first time login and change mysql root password if it is"
echo "show plugins" | mysql -uroot -pRoboShop@1 | grep "validate_password"
if [ $? -eq 0 ]; then
    echo -n "Uninstall plugin and check for mysql connections"
    echo "uninstall plugin validate_password;" > /tmp/uninstallValidatePlugin.sql
    mysql -uroot -pRoboShop@1
    stat $?
fi





# mysql_secure_installation

#mysql -uroot -pRoboShop@1
#uninstall plugin validate_password;