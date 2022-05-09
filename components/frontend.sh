#!/usr/bin/env bash

source components/common.sh

checkRootUser

 echo "install nginx"
 yum install nginx -y >/tmp/roboshop.log
 statusCheck $?

 echo "enable nginx"
 systemctl enable nginx >/tmp/roboshop.log
 statusCheck $?

 echo "Downloading frontend code"
 curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" >/tmp/roboshop.log
 statusCheck $?

 cd /usr/share/nginx/html

 echo "remove old files"
 rm -rf * >/tmp/roboshop.log
 statusCheck $?

 echo "extracting zip content"
 unzip /tmp/frontend.zip >/tmp/roboshop.log
 statusCheck $?

 echo "move files"
 mv frontend-main/* . >/tmp/roboshop.log
 mv static/* . >/tmp/roboshop.log
 rm -rf frontend-main README.md >/tmp/roboshop.log
 statusCheck $?

 echo "copy nginx config"
 mv localhost.conf /etc/nginx/default.d/roboshop.conf >/tmp/roboshop.log
 statusCheck $?

 echo "restart nginx"
 systemctl restart nginx >/tmp/roboshop.log
 statusCheck $?