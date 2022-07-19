#!/bin/bash
source components/common.sh
COMPONENTS=frontend
LOGFILE="/tmp/$COMPONENTS.log"
sw=nginx

set -e
echo "\e[32m hello I'm front end \e[0m"

echo -n "Check for root user "
checkUser
stat $?

echo -n "Install software"
installSoftware nginx
stat $?

echo -n "Downloading content"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"
stat $?

echo -n "Removing old content"
cd /usr/share/nginx/html
rm -rf *
stat $?

echo -n "Extracting content"
unzip /tmp/frontend.zip &>> $LOGFILE
stat $?

echo -n "Update Proxy file"
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
stat $?

echo -n "Restart software"
systemctl restart nginx &>> $LOGFILE
stat $?


echo "Front end script exeuted successfully"