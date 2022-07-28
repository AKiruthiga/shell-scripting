#!/bin/bash

set -e
COMPONENT=MONGODB
LOGFILE="/tmp/$COMPONENT.log"
MONGODB_REPO="https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo"
COMPONENT_REPO="https://github.com/stans-robot-project/mongodb/archive/main.zip"

source components/common.sh

echo -n "downloading the mongodb repo:"

curl -s -o /etc/yum.repos.d/mongodb.repo $MONGODB_REPO
stat $?

echo -n "installing mongodb:"
yum install -y mongodb-org &>> $LOGFILE
stat $?

echo -n "starting $COMPONENT"
systemctl enable mongod &>> $LOGFILE
systemctl start mongod &>> $LOGFILE
stat $?

echo -n "updating $COMPONENT listening address"
sed -i -e 's/127.0.0.0/0.0.0.0/' /etc/mongod.conf
stat $?

echo -n "Downloading $COMPONENT schema"
curl -s -L -o /tmp/mongodb.zip "$COMPONENT_REPO"
stat $?

cd /tmp
echo -n "extracting the schema:"
unzip -o mongodb.zip &>> $LOGFILE
stat $?

cd mongodb-main
echo -n "injecting the schema"
mongo < catalogue.js &>> $LOGFILE
mongo < users.js &>> $LOGFILE
stat $?