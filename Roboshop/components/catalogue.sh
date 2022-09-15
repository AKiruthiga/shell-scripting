#!/bin/bash

set -e
COMPONENT=catalogue
LOGFILE="/tmp/$COMPONENT.log"
APPUSER="roboshop"

source components/common.sh

#calling NODEJS function

NODEJS

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

