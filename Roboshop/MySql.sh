set -e
COMPONENT=mysql
LOGFILE="/tmp/COMPONENT.log"
source compo

# curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/stans-robot-project/mysql/main/mysql.repo
# yum install mysql-community-server -y
# systemctl enable mysqld 
# systemctl start mysqld
# grep temp /var/log/mysqld.log
# mysql_secure_installation

#mysql -uroot -pRoboShop@1
#uninstall plugin validate_password;