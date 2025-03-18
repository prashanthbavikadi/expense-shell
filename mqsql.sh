#!/bin/bash

USERID=$(id -u )
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." )
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE() {
    if [ $? -ne 0 ]
then
    echo -e "$2  $R FAILURE"
    exit1 
else 
    echo -e "$2 ... $G SUCCESS"
fi

}

if [$USERID -ne 0 ]
then 
    echo "please the run the root access"
    exit2
else
    echo " you are in root access"
fi

dnf install mysql-server -y &>>LOGFILE
VALIDATE $? "installing MYSQL server"

dnf enable mysqld  &>>LOGFILE
VALIDATE $? " enabling the MYSQL server"

dnf start mysqld &>>LOGFILE
VALIDATE $?  "Starting  the MYSQL server"


