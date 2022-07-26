#!/bin/bash
source components/common.sh
COMPONENT=catalogue
LOGFILE="/tmp/$COMPONENT.log"
CatalogueRepo="https://github.com/stans-robot-project/catalogue/archive/main.zip"
APPUSER="roboshop"

set -e
echo -e "\e[32m hello I'm Payment \e[0m"

echo -n "Check for root user "
checkUser &>> $LOGFILE
stat $?

echo -n "Install python"
yum install python36 gcc python3-devel -y 
stat $?

echo -n "Switch to roboshop ${COMPONENT} and run "
id $APPUSER &>> $LOGFILE || useradd $APPUSER 
stat $? 

echo -n "Download Repo"
cd /home/roboshop
curl -L -s -o /tmp/payment.zip "https://github.com/stans-robot-project/payment/archive/main.zip" 
unzip -o /tmp/payment.zip &>> $LOGFILE
mv payment-main payment &>> $LOGFILE
stat $?

echo -n "Install dependancies"
cd /home/roboshop/payment 
pip3 install -r requirements.txt 
stat $?

echo -n "Update payment.ini file"
uidValue = ${id -u}
gidValue = ${id -g}
echo $uidValue $gidValue
sed -i -e 's/uid = 1/$uidValue/g' /home/$APPUSER/${COMPONENT}/payment.ini  -e 's/gid = 1/$gidValue/g' /home/$APPUSER/${COMPONENT}/payment.ini
stat $?
