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
id $APPUSER &>> $LOGFILE || useradd $APPUSER
stat $?

echo -n "Perform cleanup"
cd /home/$APPUSER/ && sudo rm -rf ${COMPONENT} &>> $LOGFILE
stat $?

echo -n "Downloading $COMPONENT repo "
curl -s -L -o /tmp/${COMPONENT}.zip "$CatalogueRepo" &>> $LOGFILE
stat $?

echo -n "Extract $COMPONENT"
cd /home/roboshop/
unzip -o /tmp/${COMPONENT}.zip &>> $LOGFILE
stat $?

echo -n "Change ownership and Install npm web server"
mv ${COMPONENT}-main ${COMPONENT} && chown -R $APPUSER:$APPUSER ${COMPONENT}
cd ${COMPONENT}
npm install &>> $LOGFILE
stat $?

echo -n "Update Mongodb Endpoint"
sed -i -e 's/MONGO_DNSNAME/172.31.5.168/g' /home/$APPUSER/${COMPONENT}/systemd.service
stat $?

echo -n "Update Mongodb Endpoint"
mv /home/$APPUSER/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
systemctl daemon-reload
systemctl start ${COMPONENT}
systemctl enable ${COMPONENT}
systemctl status ${COMPONENT} -l
stat $?