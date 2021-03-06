#!/usr/bin/env bash

source components/common.sh

checkRootUser

 ECHO "install nginx"
 yum install nginx -y &>>$LOG_FILE
 statusCheck $?

 ECHO "Downloading frontend code"
 curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG_FILE
 statusCheck $?

 cd /usr/share/nginx/html

 ECHO "remove old files"
 rm -rf * &>>$LOG_FILE
 statusCheck $?

 ECHO "extracting zip content"
 unzip /tmp/frontend.zip &>>$LOG_FILE
 statusCheck $?

 ECHO "move files"
 mv frontend-main/* . &>>$LOG_FILE && mv static/* . &>>$LOG_FILE && rm -rf frontend-main README.md &>>$LOG_FILE
 statusCheck $?

 ECHO "copy nginx config"
 mv localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE
 statusCheck $?

 ECHO "update nginx config"
 sed -i -e '/catalogue/ s/localhost/catalogue.roboshop.internal/' -e '/user/ s/localhost/user.roboshop.internal/' -e '/cart/ s/localhost/cart.roboshop.internal/' -e '/shipping/ s/localhost/shipping.roboshop.internal/' -e '/payment/ s/localhost/payment.roboshop.internal/' /etc/nginx/default.d/roboshop.conf
 statusCheck $?


 ECHO "restart nginx"
 systemctl enable nginx &>>${LOG_FILE} && systemctl restart nginx &>>${LOG_FILE}
 statusCheck $?