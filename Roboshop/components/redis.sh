#!/bin/bash

set -e
COMPONENT=redis
LOGFILE="/tmp/$COMPONENT.log"
APPUSER="roboshop"

source components/common.sh

echo -n "configuring the $component repo:"
curl -L https://raw.githubusercontent.com/stans-robot-project/$COMPONENT/main/$COMPONENT.repo -o /etc/yum.repos.d/redis.repo
stat $?

echo -n "Installing $component "
yum install redis-6.2.7 -y &>> $LOGFILE
stat $?

#2. Update the BindIP from 127.0.0.1 to 0.0.0.0 in config file /etc/redis.conf & /etc/redis/redis.conf

# vim /etc/redis.conf
# vim /etc/redis/redis.conf

# systemctl enable redis
# systemctl start redis
# systemctl status redis -l