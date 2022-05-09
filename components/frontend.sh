#!/usr/bin/env bash

source components/common.sh

checkRootUser

 yum install nginx -y >/tmp/roboshop.log
 systemctl enable nginx >/tmp/roboshop.log
 curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" >/tmp/roboshop.log
 cd /usr/share/nginx/html >/tmp/roboshop.log
 rm -rf * >/tmp/roboshop.log
 unzip /tmp/frontend.zip >/tmp/roboshop.log
 mv frontend-main/* . >/tmp/roboshop.log
 mv static/* . >/tmp/roboshop.log
 rm -rf frontend-main README.md >/tmp/roboshop.log
 mv localhost.conf /etc/nginx/default.d/roboshop.conf >/tmp/roboshop.log

 systemctl restart nginx >/tmp/roboshop.log
