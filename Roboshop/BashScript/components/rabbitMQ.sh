#!/bin/bash
source components/common.sh
COMPONENT="rabbitmq-server"
LOGFILE="/tmp/$COMPONENT.log"
APPUSER="roboshop"
mqDependancyProjRepo="https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm"
mqPackage="https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh"
set -e
echo -e "\e[32m hello I'm Rabbit MQ \e[0m"

echo -n "Check for root user "
checkUser
stat $?

echo -n "Perform cleanup"
cd /home/$APPUSER/ && sudo rm -rf ${COMPONENT} &>> $LOGFILE
stat $?

echo -n "Erlang is a dependency that is needed for ${COMPONENT} "
yum install $mqDependancyProjRepo -y &>> $LOGFILE


echo -n "Download and install ${COMPONENT} "
curl -s $mqPackage | sudo bash &>> $LOGFILE
yum install ${COMPONENT} -y &>> $LOGFILE
stat $?

echo -n "Start ${COMPONENT}  "
systemctl enable ${COMPONENT} 
systemctl start ${COMPONENT}
systemctl status ${COMPONENT} -l
stat $?

echo -n "Add and set user tags for ${COMPONENT} "
rabbitmqctl add_user $APPUSER roboshop123
rabbitmqctl set_user_tags $APPUSER administrator
rabbitmqctl set_permissions -p / $APPUSER ".*" ".*" ".*"
stat $?