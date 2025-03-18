#!/bin/bash

USERID=$(id -u )
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 |cut -d "." -f1 )
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
Y="\e[32m"
Y="\e[33m"
N="\e[0m"


VALIDATE(){
if [$1 -ne 0 ]
then 
    echo "$2 ...FAILURE"
    exit2
else 
    echo "$2.... SUCCESS"
}

if [ $USERID -ne 0 ]
then 
    echo "please run this script with root access"
    exit2
else 
    echo " you are in superuser"
fi

dnf module disable nodejs -y
VALIDATE $? "Disabling the Nodejs"

dnf module enable nodejs:20 -y
VALIDATE $? "Enableing the Nodejs:20"

dnf install nodejs -y
VALIDATE $? "Enableing the Nodejs:20"