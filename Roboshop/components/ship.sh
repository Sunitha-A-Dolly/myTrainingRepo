#!/bin/bash
source components/common.sh
COMPONENT=ship
LOGFILE="/tmp/$COMPONENT.log"
APPUSER="roboshop"
shipProjRepo="https://github.com/stans-robot-project/shipping/archive/main.zip"

set -e
echo -e "\e[32m hello I'm Ship \e[0m"

echo -n "Check for root user "
checkUser
stat $?

echo -n "Install maven"
yum install maven -y
stat $?

echo -n "Switch to roboshop ${COMPONENT} "
id $APPUSER &>> $LOGFILE || useradd $APPUSER
stat $?

echo -n "Perform cleanup"
cd /home/$APPUSER/ && sudo rm -rf ${COMPONENT} &>> $LOGFILE
stat $?

echo -n "Download shipping project"
cd /home/roboshop
curl -s -L -o /tmp/shipping.zip ${shipProjRepo}
stat $?

echo -n "Extract project"
unzip -o /tmp/shipping.zip
mv shipping-main shipping
cd shipping
mvn clean package 
mv target/shipping-1.0.jar shipping.jar

echo -n "Update CARTENDPOINT and DBHOST  Endpoint"
sed -i -e 's/CARTENDPOINT/172.31.6.30/g' /home/$APPUSER/${COMPONENT}/systemd.service  -e 's/DBHOST/172.31.3.237/g' /home/$APPUSER/${COMPONENT}/systemd.service
stat $?

echo -n "Move shipping files and start"
mv /home/roboshop/shipping/systemd.service /etc/systemd/system/shipping.service
systemctl daemon-reload
systemctl start shipping 
systemctl enable shipping
systemctl status shipping -l 
stat $?