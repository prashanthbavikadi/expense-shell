#!/bin/bash

USERID=$(id -u )
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 |cut -d "." -f1 )
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
Y="\e[32m"
Y="\e[33m"
N="\e[0m"

echo "Please provide DB password:"
read -s mysql_root_password

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
VALIDATE $? "Installing nodejs dependencies"

#check your repo and path
cp /home/ec2-user/expense-shell/backend.service /etc/systemd/system/backend.service

systemctl daemon-reload >>$LOGFILE
VALIDATE $? "Reloading the deamon"

systemctl start backend >>$LOGFILE
VALIDATE $? "Starting backend"

systemctl enable backend  >>$LOGFILE
VALIDATE $? "Enabling backend"

dnf install mysql -y &>>$LOGFILE
VALIDATE $? "Installing MySQL Client"

mysql -h db.apaws10s.online -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE
VALIDATE $? "Schema loading"

systemctl restart backend &>>$LOGFILE
VALIDATE $? "Restarting Backend"