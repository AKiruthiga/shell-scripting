#!/bin/bash

set -e
COMPONENT=MONGODB
LOGFILE="/tmp/$COMPONENT.log"
MONGODB_REPO="https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo"

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

echo -n "updating #COMPONENT listening address"
sed -i -e 's/127.0.0.0/0.0.0.0/' /etc/mongod.conf
stat $?

# vim /etc/mongod.conf
# systemctl restart mongod
# curl -s -L -o /tmp/mongodb.zip "https://github.com/stans-robot-project/mongodb/archive/main.zip"

# cd /tmp
# unzip mongodb.zip
# cd mongodb-main
# mongo < catalogue.js
# mongo < users.js