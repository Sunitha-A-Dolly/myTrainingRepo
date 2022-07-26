#!/bin/bash
source components/common.sh
COMPONENT=catalogue
LOGFILE="/tmp/$COMPONENT.log"
CatalogueRepo="https://github.com/stans-robot-project/catalogue/archive/main.zip"
APPUSER="roboshop"

set -e
echo -e "\e[32m hello I'm Payment \e[0m"

echo -n "Check for root user "
checkUser
stat $?

echo -n "Download Repo"
cd /home/roboshop
curl -L -s -o /tmp/payment.zip "https://github.com/stans-robot-project/payment/archive/main.zip"
unzip -o /tmp/payment.zip
stat $?

echo -n "Install dependancies"
cd /home/roboshop/payment 
pip3 install -r requirements.txt
stat $?
