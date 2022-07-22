#!/bin/bash
source components/common.sh
COMPONENT=user
nodeJSApplication=nodejs
LOGFILE="/tmp/$COMPONENT.log"
nodejsRepo="https://rpm.nodesource.com/setup_lts.x"
APPUSER="roboshop"
userProjRepo="https://github.com/stans-robot-project/user/archive/main.zip"

set -e
echo -e "\e[32m hello I'm User \e[0m"

echo -n "Check for root user "
checkUser
stat $?


echo -n "Installing $nodeJSApplication"
curl -sL $nodejsRepo | bash &>> $LOGFILE
yum install $nodeJSApplication -y &>> $LOGFILE
stat $?

echo -n "Switch to roboshop ${COMPONENT} and run "
id $APPUSER &>> $LOGFILE || useradd $APPUSER
stat $?

echo -n "Perform cleanup"
cd /home/$APPUSER/ && sudo rm -rf ${COMPONENT} &>> $LOGFILE
stat $?

echo -n "Download User project"
curl -s -L -o /tmp/${COMPONENT}.zip ${userProjRepo} &>> $LOGFILE
stat $?

echo -n "Unzip ${COMPONENT} project"
cd /home/$APPUSER
unzip -o /tmp/${COMPONENT}.zip &>> $LOGFILE
stat $?

echo -n "Install npm as $APPUSER ${COMPONENT}"
mv ${COMPONENT}-main ${COMPONENT}
cd /home/$APPUSER/${COMPONENT}
npm install &>> $LOGFILE
stat $?

echo -n "Update Redis and Mongodb Endpoint"
echo -n  "/home/$APPUSER/${COMPONENT}/systemd.service"
sed -i -e 's/REDIS_ENDPOINT/172.31.15.228/g' /home/$APPUSER/${COMPONENT}/systemd.service  -e 's/MONGO_ENDPOINT/172.31.15.221/g' /home/$APPUSER/${COMPONENT}/systemd.service
stat $?

echo -n "Enable system service"
mv /home/$APPUSER/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>> $LOGFILE
systemctl daemon-reload
systemctl start ${COMPONENT}
systemctl enable ${COMPONENT} &>> $LOGFILE
stat $?