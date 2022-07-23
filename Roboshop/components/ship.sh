#!/bin/bash
source components/common.sh
COMPONENT=shipping
LOGFILE="/tmp/$COMPONENT.log"
APPUSER="roboshop"
shipProjRepo="https://github.com/stans-robot-project/shipping/archive/main.zip"

set -e
echo -e "\e[32m hello I'm Ship \e[0m"

echo -n "Check for root user "
checkUser
stat $?

echo -n "Install maven"
yum install maven -y &>> $LOGFILE
stat $?

echo -n "Switch to roboshop ${COMPONENT} "
id $APPUSER &>> $LOGFILE || useradd $APPUSER
stat $?

echo -n "Perform cleanup"
cd /home/$APPUSER/ && sudo rm -rf ${COMPONENT} &>> $LOGFILE
stat $?

echo -n "Download ${COMPONENT} project"
cd /home/roboshop
curl -s -L -o /tmp/${COMPONENT}.zip ${shipProjRepo} &>> $LOGFILE
stat $?

echo -n "Extract project"
unzip -o /tmp/${COMPONENT}.zip &>> $LOGFILE
mv ${COMPONENT}-main ${COMPONENT}
cd ${COMPONENT}
mvn clean package  &>> $LOGFILE
mv target/${COMPONENT}-1.0.jar ${COMPONENT}.jar 

echo -n "Update CARTENDPOINT and DBHOST  Endpoint"
sed -i -e 's/CARTENDPOINT/172.31.6.30/g' /home/$APPUSER/${COMPONENT}/systemd.service  -e 's/DBHOST/172.31.3.237/g' /home/$APPUSER/${COMPONENT}/systemd.service &>> $LOGFILE
stat $?

echo -n "Move shipping files and start"
mv /home/$APPUSER/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
systemctl daemon-reload &>> $LOGFILE
systemctl start ${COMPONENT}  &>> $LOGFILE
systemctl enable ${COMPONENT} &>> $LOGFILE
systemctl status ${COMPONENT} -l &>> $LOGFILE
stat $?