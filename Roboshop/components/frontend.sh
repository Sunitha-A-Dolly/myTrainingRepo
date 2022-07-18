#!/bin/bash
source components/common.sh

set -e
echo "hello I'm front end"

userid = $(id -u)
if [$userid -ne 0] ;then
    echo "You need to be a root user"
    exit 1
fi

 yum install nginx -y
    systemctl enable nginx
    systemctl start nginx

curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"
cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
systemctl restart nginx