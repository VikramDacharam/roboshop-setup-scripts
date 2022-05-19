#!/usr/bin/env bash
source components/common.sh
checkRootUser


# curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo
# yum install redis-6.2.7 -y
# Update the BindIP from 127.0.0.1 to 0.0.0.0 in config file /etc/redis.conf & /etc/redis/redis.conf
# systemctl enable redis
# systemctl start redis

ECHO "configure yum repos"
curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>${LOG_FILE}
statusCheck $?

ECHO "install redis"
yum install redis-6.2.7 -y &>>${LOG_FILE}
statusCheck $?

ECHO "Update redis configuration"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf &>>${LOG_FILE}
statusCheck $?

ECHO "start redis service"
systemctl enable redis &>>${LOG_FILE} && systemctl start redis &>>${LOG_FILE}
statusCheck $?
