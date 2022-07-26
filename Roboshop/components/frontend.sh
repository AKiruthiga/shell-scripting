#!/bin/bash
set -e
COMPONENT=frontend
LOGFILE="/tmp/$COMPONENT.log"

source components/common.sh


echo -n "installing the nginx:"
yum install nginx -y &>> $LOGFILE
stat $?

systemctl enable nginx &>> $LOGFILE
echo -n "starting nginx:"
systemctl start nginx
stat $?

echo -n "Downloading and extracting $COMPONENT:"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"
stat $?

echo -n "clearing the old content:"
cd /usr/share/nginx/html
rm -rf *
stat $?

echo -n "extracting the downloaded content:"
unzip /tmp/frontend.zip &>> $LOGFILE
stat $?

echo -n "updating the proxy file:"
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
stat $?