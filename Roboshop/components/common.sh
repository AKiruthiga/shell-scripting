#!/bin/bash

USER_ID=$(id -u)
if [ $USER_ID -ne 0 ] ; then
    echo -e "\e[31m you need to run it as a root user \e[0m"
    exit 1
fi 

stat() { 
    if [ $1 -eq 0 ] ; then
        echo -e "\e[32m SUCCESS \e[0m"
    else
        echo -e "\e[31m FAILURE \e[0m"
    fi
}

NODEJS(){
    echo -n "configuring Nodejs repo:"
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOGFILE
    stat $?

    echo -n "installing Nodejs repo:"
    yum install nodejs -y &>> $LOGFILE
    stat $?

    #Calling create_user function
    CREATE_USER

    #Calling DOWNLOAD_AND_EXTRACT function
    DOWNLOAD_AND_EXTRACT

    echo -n "installing $COMPONENT:"
    cd /home/roboshop/$COMPONENT/
    npm install &>> $LOGFILE
    stat $?

    #CALLING CONFIGURE SERVICE
    CONFIG_SERVICE
    #CALLING START SERVICE
    START_SERVICE
}

CREATE_USER(){
    echo -n "creating the roboshop user:"
    id roboshop &>> $LOGFILE || useradd roboshop 
    stat $?
}

DOWNLOAD_AND_EXTRACT(){
    echo -n "downloading $COMPONENT repo:"
    curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip" &>> $LOGFILE
    stat $?

    echo -n "Performing cleanup:"
    cd /home/roboshop &&  rm -rf ${COMPONENT} &>> $LOGFILE
    stat $?

    echo -n "Extracting $COMPONENT:"
    cd /home/roboshop
    unzip -o /tmp/catalogue.zip &>> $LOGFILE
    mv catalogue-main catalogue && chown -R $APPUSER:$APPUSER $COMPONENT
    cd ${component}
    stat $?
}

CONFIG_SERVICE(){
    echo -n "Configuring $COMPONENT service:"
    sed -i -e 's/MONGO_DNSNAME/mongodb.robocopy.internal/' systemd.service
    mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
    stat $?
}

START_SERVICE(){
    echo -n "starting $COMPONENT service:"
    systemctl daemon-reload
    systemctl start $COMPONENT
    systemctl enable $COMPONENT &>> $LOGFILE
    systemctl status $COMPONENT -l &>> $LOGFILE
    stat $?
}