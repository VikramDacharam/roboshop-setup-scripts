#!/usr/bin/env bash

source components/common.sh

checkRootUser

 echo "install nginx"
 yum install nginx -y >>$LOG_FILE
 statusCheck $?

 echo "enable nginx"
 systemctl enable nginx >>$LOG_FILE
 statusCheck $?

 echo "Downloading frontend code"
 curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" >>$(LOG_FILE)
 statusCheck $?

 cd /usr/share/nginx/html

 echo "remove old files"
 rm -rf * >>$(LOG_FILE)
 statusCheck $?

 echo "extracting zip content"
 unzip /tmp/frontend.zip >>$(LOG_FILE)
 statusCheck $?

 echo "move files"
 mv frontend-main/* . >>$(LOG_FILE)
 mv static/* . >>$(LOG_FILE)
 rm -rf frontend-main README.md >>$(LOG_FILE)
 statusCheck $?

 echo "copy nginx config"
 mv localhost.conf /etc/nginx/default.d/roboshop.conf >>$(LOG_FILE)
 statusCheck $?

 echo "restart nginx"
 systemctl restart nginx >>$(LOG_FILE)
 statusCheck $?