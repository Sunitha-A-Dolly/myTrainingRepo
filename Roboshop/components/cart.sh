#!/bin/bash
source components/common.sh
COMPONENT=cart
nodeJSApplication=nodejs
LOGFILE="/tmp/$COMPONENT.log"
nodejsRepo="https://rpm.nodesource.com/setup_lts.x"
APPUSER="roboshop"
cartProjRepo="https://github.com/stans-robot-project/cart/archive/main.zip"

set -e
echo -e "\e[32m hello I'm Cart \e[0m"

echo -n "Check for root user "
checkUser
stat $?

echo -n "Install nodejs"
curl -sL ${nodejsRepo} | bash &>> $LOGFILE
yum install ${nodeJSApplication} -y &>> $LOGFILE
stat $?

echo -n "Switch to roboshop user"
id $APPUSER &>> $LOGFILE || useradd $APPUSER &>> $LOGFILE
stat $?

echo -n "Perform cleanup"
cd /home/$APPUSER/ && sudo rm -rf ${COMPONENT} &>> $LOGFILE
stat $?

echo -n "Download from repo Cart project"
curl -s -L -o /tmp/cart.zip $cartProjRepo &>> $LOGFILE
stat $?

echo -n "Extract Cart Project"
cd /home/roboshop
unzip -o /tmp/cart.zip &>> $LOGFILE
stat $?

echo -n "Install npm"
mv cart-main cart
cd cart
npm install &>> $LOGFILE
stat $?

echo -n "Update Redis and Catalogue Endpoint"
sed -i -e 's/REDIS_ENDPOINT/172.31.15.228/g' /home/$APPUSER/${COMPONENT}/systemd.service -e 's/CATALOGUE_ENDPOINT/172.31.14.231/g' /home/$APPUSER/${COMPONENT}/systemd.service &>> $LOGFILE
stat $?

echo -n "Enable system service"
mv /home/$APPUSER/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>> $LOGFILE
systemctl daemon-reload &>> $LOGFILE
systemctl start ${COMPONENT} &>> $LOGFILE
systemctl enable ${COMPONENT} &>> $LOGFILE
stat $?

echo -n "Cart status"
systemctl status cart -l 
stat $?