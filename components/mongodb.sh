#!/usr/bin/env bash
source components/common.sh
checkRootUser
# yum install -y mongodb-org
# systemctl enable mongod
# systemctl start mongod
# systemctl restart mongod
# curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"

# cd /tmp
# unzip mongodb.zip
# cd mongodb-main
# mongo < catalogue.js
# mongo <
# users.js

ECHO "Setup Mongodb yum repo"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>${LOG_FILE}
statusCheck $?

ECHO "installing mongodb"
yum install -y mongodb-org-5.0.8 &>>${LOG_FILE}
statusCheck $?

ECHO "configure listen Address in Mongodb configuration"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
statusCheck $?

ECHO "start mongodb service"
systemctl restart mongod &>>${LOG_FILE} && systemctl enable mongod >>${LOG_FILE}
statusCheck $?

ECHO "Download schema"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" >>${LOG_FILE}
statusCheck $?

ECHO "extract shcema zip"
cd /tmp && unzip -o mongodb.zip >>${LOG_FILE}
statusCheck $?

cd mongodb-main
ECHO "Load schema"
mongo < catalogue.js >>${LOG_FILE}  && mongo < users.js >>${LOG_FILE}
statusCheck $?