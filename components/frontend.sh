#!/usr/bin/env bash

source components/common.sh

checkRootUser

 echo "install nginx"
 yum install nginx -y >>$(Log_File)
 statusCheck $?

 echo "enable nginx"
 systemctl enable nginx >>$(Log_File)
 statusCheck $?

 echo "Downloading frontend code"
 curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" >>(Log_File)
 statusCheck $?

 cd /usr/share/nginx/html

 echo "remove old files"
 rm -rf * >>$(Log_File)
 statusCheck $?

 echo "extracting zip content"
 unzip /tmp/frontend.zip >>$(Log_File)
 statusCheck $?

 echo "move files"
 mv frontend-main/* . >>$(Log_File)
 mv static/* . >>$(Log_File)
 rm -rf frontend-main README.md >>$(Log_File)
 statusCheck $?

 echo "copy nginx config"
 mv localhost.conf /etc/nginx/default.d/roboshop.conf >>$(Log_File)
 statusCheck $?

 echo "restart nginx"
 systemctl restart nginx >>$(Log_File)
 statusCheck $?