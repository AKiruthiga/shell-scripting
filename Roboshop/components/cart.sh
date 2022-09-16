#!/bin/bash

set -e
COMPONENT=catalogue
LOGFILE="/tmp/$COMPONENT.log"
APPUSER="roboshop"

source components/common.sh

#calling NODEJS function

NODEJS