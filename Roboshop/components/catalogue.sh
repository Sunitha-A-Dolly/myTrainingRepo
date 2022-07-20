#!/bin/bash
source components/common.sh
COMPONENT=catalogue
LOGFILE="/tmp/$COMPONENT.log"
CatalogueRepo="https://github.com/stans-robot-project/catalogue/archive/main.zip"
APPUSER="roboshop"

set -e
echo -e "\e[32m hello I'm Catalogue \e[0m"

echo -n "Check for root user "
checkUser
stat $?

echo -n "Configuring nodeJS"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOGFILE
stat $?

echo -n "Installing nodeJS"
yum install nodejs -y &>> $LOGFILE
stat $?

echo -n "Switch to roboshop user and run "
id roboshop &>> $LOGFILE || useradd roboshop
stat $?

echo -n "Perform cleanup"
cd /home/roboshop/ && sudo rm -rf ${COMPONENT} &>> $LOGFILE
stat $?

echo -n "Downloading $COMPONENT repo "
curl -s -L -o /tmp/${COMPONENT}.zip "$CatalogueRepo" &>> $LOGFILE
stat $?

echo -n "Extract $COMPONENT"
cd /home/roboshop/
unzip -o /tmp/${COMPONENT}.zip &>> $LOGFILE
stat $?

echo "Change ownership and Install npm web server"
mv ${COMPONENT}-main ${COMPONENT} && chown -R $APPUSER:$APPUSER ${COMPONENT}
cd ${COMPONENT}
npm install &>> $LOGFILE
stat $?