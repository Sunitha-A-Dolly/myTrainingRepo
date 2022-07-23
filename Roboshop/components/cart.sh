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
curl -sL ${nodejsRepo} | bash
yum install ${nodeJSApplication} -y
stat $?

echo -n "Switch to roboshop user"
id $APPUSER &>> $LOGFILE || useradd $APPUSER
stat $?

echo -n "Perform cleanup"
cd /home/$APPUSER/ && sudo rm -rf ${COMPONENT} &>> $LOGFILE
stat $?

echo -n "Download from repo Cart project"
curl -s -L -o /tmp/cart.zip $cartProjRepo
stat $?

echo -n "Extract Cart Project"
cd /home/roboshop
unzip -o /tmp/cart.zip
stat $?

echo -n "Install npm"
mv cart-main cart
cd cart
npm install
stat $?

echo -n "Update Redis and Mongodb Endpoint"
sed -i -e 's/REDIS_ENDPOINT/172.31.15.228/g' /home/$APPUSER/${COMPONENT}/systemd.service  -e 's/MONGO_ENDPOINT/172.31.15.221/g' /home/$APPUSER/${COMPONENT}/systemd.service
stat $?

echo -n "Enable system service"
mv /home/$APPUSER/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>> $LOGFILE
systemctl daemon-reload
systemctl start ${COMPONENT}
systemctl enable ${COMPONENT} &>> $LOGFILE
stat $?