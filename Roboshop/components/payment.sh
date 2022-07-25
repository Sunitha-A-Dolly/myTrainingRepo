#!/bin/bash
source components/common.sh
COMPONENT=catalogue
LOGFILE="/tmp/$COMPONENT.log"
CatalogueRepo="https://github.com/stans-robot-project/catalogue/archive/main.zip"
APPUSER="roboshop"

set -e
echo -e "\e[32m hello I'm Catalogue \e[0m"

echo -n "Check for root user "
checkUser
stat $?