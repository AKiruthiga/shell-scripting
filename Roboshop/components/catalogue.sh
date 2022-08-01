#!/bin/bash

set -e
COMPONENT=catalogue
LOGFILE="/tmp/$COMPONENT.log"

source components/common.sh

echo -n "configuring Nodejs repo:"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOGFILE
stat $?

echo -n "installing Nodejs repo:"
yum install nodejs -y &>> $LOGFILE
stat $?

echo -n "creating the roboshop user:"
id roboshop &>> $LOGFILE || useradd roboshop 
stat $?

echo -n "downloading $COMPONENT repo:"
curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip" &>> $LOGFILE
stat $?

echo -n "Performing cleanup:"
cd /home/roboshop &&  rm -rf ${COMPONENT} &>> $LOGFILE
stat $?

echo -n "Extracting $COMPONENT:"
cd /home/roboshop
unzip -o /tmp/catalogue.zip &>> $LOGFILE
mv catalogue-main catalogue
cd /home/roboshop/catalogue

echo -n "installing $COMPONENT:"
npm install &>> $LOGFILE
stat $?

#vim systemd.servce
# # mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
# # systemctl daemon-reload
# # systemctl start catalogue
# # systemctl enable catalogue
# # systemctl status catalogue -l

# NOTE: You should see the log saying `connected to MongoDB`, then only your catalogue
# will work and can fetch the items from MongoDB

# Ref Log:
# {"level":"info","time":1656660782066,"pid":12217,"hostname":"ip-172-31-13-123.ec2.internal","msg":"MongoDB connected","v":1}

# # vim /etc/nginx/default.d/roboshop.conf

# # systemctl restart nginx

# # systemctl restart nginx

