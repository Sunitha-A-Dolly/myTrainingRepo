#!/bin/bash
source components/common.sh
COMPONENT=mongod
LOGFILE="/tmp/$COMPONENTS.log"
MongodRepo="https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo"
sw=nginx

set -e
echo -e "\e[32m hello I'm MONGODB \e[0m"

echo -n "Check for root user "
checkUser
stat $?


echo -n "Extract sw "
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo
stat $?

echo -n "Install software"
yum install -y mongodb-org &>> $LOGFILE
systemctl enable mongod &>> $LOGFILE
systemctl restart mongod &>> $LOGFILE
stat $?

echo -n "Replace ip for Mongodb to be accessible to all"
sed -i  's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf 
stat $?

echo -n "Restart service after config file change"
systemctl restart mongod &>> $LOGFILE
stat $?

echo -n "Download the schema and inject it"
curl -s -L -o /tmp/mongodb.zip "https://github.com/stans-robot-project/mongodb/archive/main.zip"
stat $?

echo -n "Extract file to import schema"
cd /tmp
unzip mongodb.zip
stat $?

echo -n "Run the java script to import mysql schema"
cd mongodb-main
mongo < catalogue.js
mongo < users.js
stat $?
echo -n "Executed Mongodb successfully"
