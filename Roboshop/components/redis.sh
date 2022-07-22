#!/bin/bash
source components/common.sh
COMPONENT=redis
LOGFILE="/tmp/$COMPONENT.log"
RedisRepo="https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo"
APPUSER="roboshop"

set -e
echo -e "\e[32m hello I'm Catalogue \e[0m"

echo -n "Check for root user "
checkUser
stat $?


echo -n "Installing ${COMPONENT}"
curl -L $RedisRepo -o /etc/yum.repos.d/${COMPONENT}.repo &>> $LOGFILE
yum install ${COMPONENT}-6.2.7 -y &>> $LOGFILE
stat $?

echo -n "Configuring ${COMPONENT}"
sed -i -e 's/127.0.0.1/0.0.0.0/g' /etc/${COMPONENT}/${COMPONENT}.conf  -e 's/127.0.0.1/0.0.0.0/g' /etc/${COMPONENT}.conf &>> $LOGFILE
stat $?

echo -n "Start service ${COMPONENT}"
systemctl enable ${COMPONENT} &>> $LOGFILE
systemctl start ${COMPONENT}  &>> $LOGFILE
systemctl status ${COMPONENT} -l &>> $LOGFILE
stat $?