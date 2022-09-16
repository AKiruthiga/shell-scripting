#!/bin/bash

set -e
COMPONENT=user
LOGFILE="/tmp/$COMPONENT.log"
APPUSER="roboshop"

source components/common.sh

#calling NODEJS function

NODEJS