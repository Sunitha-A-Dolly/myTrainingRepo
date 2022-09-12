#!/bin/bash
source components/common.sh
COMPONENT=dispatch
LOGFILE="/tmp/$COMPONENT.log"
APPUSER="roboshop"
dispatchProjRepo="https://github.com/stans-robot-project/dispatch/archive/refs/heads/main.zip"

set -e
echo -e "\e[32m hello I'm ${COMPONENT} \e[0m"

echo -n "Check for root user "
checkUser
stat $?


echo -n "Installing golang"
 yum install golang -y
stat $?

echo -n "Switch to roboshop ${COMPONENT} and run "
id $APPUSER &>> $LOGFILE || useradd $APPUSER
stat $?

echo -n "Perform cleanup"
cd /home/$APPUSER/ && sudo rm -rf ${COMPONENT} &>> $LOGFILE
stat $?

echo -n "Download ${COMPONENT} project"
curl -s -L -o /tmp/${COMPONENT}.zip ${dispatchProjRepo} &>> $LOGFILE
stat $?

echo -n "Unzip ${COMPONENT} project"
cd /home/$APPUSER
unzip /tmp/${COMPONENT}.zip &>> $LOGFILE
stat $?

echo -n "Run few golang commands"
mv ${COMPONENT}-main ${COMPONENT}
cd ${COMPONENT}
go mod init dispatch
go get
go build
stat $?

echo -n "Enable system service"
mv /home/$APPUSER/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>> $LOGFILE
systemctl daemon-reload
systemctl start ${COMPONENT}
systemctl enable ${COMPONENT} &>> $LOGFILE
stat $?