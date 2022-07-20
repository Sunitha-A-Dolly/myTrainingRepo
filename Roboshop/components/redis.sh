#!/bin/bash
source components/common.sh
COMPONENT=redis
LOGFILE="/tmp/$COMPONENT.log"
CatalogueRepo="https://github.com/stans-robot-project/catalogue/archive/main.zip"
APPUSER="roboshop"

set -e
echo -e "\e[32m hello I'm Catalogue \e[0m"

echo -n "Check for root user "
checkUser
stat $?


echo -n "Installing ${COMPONENT}"
curl -L https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo
yum install redis-6.2.7 -y
stat $?

echo -n "Configuring ${COMPONENT}"
sed -i  's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf 
stat $?

echo -n "Start ${COMPONENT}"
systemctl enable redis
systemctl start redis
systemctl status redis -l