#!/bin/bash
source components/common.sh
COMPONENT=payment
LOGFILE="/tmp/$COMPONENT.log"
CatalogueRepo="https://github.com/stans-robot-project/catalogue/archive/main.zip"
APPUSER="roboshop"

set -e
echo -e "\e[32m hello I'm Payment \e[0m"

echo -n "Check for root user "
checkUser &>> $LOGFILE
stat $?

echo -n "Install python"
yum install python36 gcc python3-devel -y &>> $LOGFILE
stat $?

echo -n "Switch to roboshop ${COMPONENT} and run "
id $APPUSER &>> $LOGFILE || useradd $APPUSER &>> $LOGFILE
stat $? 

echo -n "Perform cleanup"
cd /home/$APPUSER/ && sudo rm -rf ${COMPONENT} &>> $LOGFILE
stat $?

echo -n "Download Repo"
cd /home/roboshop
curl -L -s -o /tmp/payment.zip "https://github.com/stans-robot-project/payment/archive/main.zip"  &>> $LOGFILE
unzip -o /tmp/payment.zip &>> $LOGFILE
mv payment-main payment &>> $LOGFILE
stat $?

echo -n "Install dependancies"
cd /home/roboshop/payment 
pip3 install -r requirements.txt  &>> $LOGFILE
stat $?

echo -n "Update payment.ini file "
uidValue=$(id -u $APPUSER )
gidValue=$(id -g $APPUSER)
echo $uidValue $gidValue
sed -i -e "/uid/ c uid = $uidValue" -e "/gid/ c gid = $gidValue" payment.ini
stat $?


echo -n "Replace ip"
sed -i -e 's/CARTHOST/172.31.6.30/g' systemd.service -e 's/USERHOST/172.31.1.91/g' systemd.service -e 's/AMQPHOST/172.31.13.236/g' systemd.service
stat $?

echo -n "Restart payment service"
mv /home/roboshop/payment/systemd.service /etc/systemd/system/payment.service
systemctl daemon-reload
systemctl enable payment 
systemctl start payment
systemctl status payment -l
stat $?
