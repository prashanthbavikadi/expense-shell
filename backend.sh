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
if [ $1 -ne 0 ]
then 
    echo "$2 ...FAILURE"
    exit1
else 
    echo "$2.... SUCCESS"
fi

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
VALIDATE $? "Installing the nodejs"

id expense
if [ $? -ne 0 ]
then 
    useradd expense
    VALIDATE $? "please create the user if not exit" 
else
    echo "Already user is existed ...$Y SKPPOING FOR NOW $N"
fi

mkdir -p /app 
VALIDATE $? "Creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
VALIDATE $? "unzipping the file"

cd /app
rm -rf /app/*
unzip /tmp/backend.zip
VALIDATE $? "Unzipping the backend file"
cd /app
npm  install