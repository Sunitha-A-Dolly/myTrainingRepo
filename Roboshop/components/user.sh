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


echo -n "Download User project"
curl -s -L -o /tmp/${COMPONENT}.zip ${userProjRepo} &>> $LOGFILE
stat $?

echo -n "Unzip ${COMPONENT} project"
cd /home/$APPUSER
unzip /tmp/${COMPONENT}.zip &>> $LOGFILE
stat $?

echo -n "Install npm as $APPUSER ${COMPONENT}"
mv ${COMPONENT}-main ${COMPONENT}
cd /home/$APPUSER/${COMPONENT}
npm install &>> $LOGFILE
stat $?

