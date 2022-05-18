#!/usr/bin/env bash

source components/common.sh
checkRootUser


# useradd roboshop
# $ curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"
# $ cd /home/roboshop
# $ unzip /tmp/catalogue.zip
# $ mv catalogue-main catalogue
# $ cd /home/roboshop/catalogue
# $ npm install

# mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
# systemctl daemon-reload
# systemctl start catalogue
# systemctl enable catalogue

ECHO "configure NodeJs Yum Repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
statusCheck $?

ECHO "Install nodejs"
yum install nodejs gcc-c++ -y &>>${LOG_FILE}
statusCheck $?

id roboshop &>>{LOG_FILE}

if [ $? -ne 0 ]; then
  ECHO "Add Application user"
  useradd roboshop &>>${LOG_FILE}
  statusCheck $?
fi

ECHO "download application content"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"
statusCheck $?

ECHO "Extract Application Archieve"
cd /home/roboshop && unzip /tmp/catalogue.zip &>>${LOG_FILE} && mv catalogue-main catalogue &>>${LOG_FILE}
statusCheck $?

ECHO "Install NodeJs Modules"
cd /home/roboshop/catalogue && npm install &>>${LOG_FILE} && chown roboshop:roboshop /home/roboshop/catalogue -R
statusCheck $?

ECHO "update systemd configure files"
sed -i -e 's/MANGO_DNSNAME/mongodb.roboshop.internal/' /home/roboshop/catalogue/systemd.service
statusCheck $?

ECHO "setup systemd services"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
systemctl daemon-reload &>>${LOG_FILE} && systemctl start catalogue &>>${LOG_FILE} && systemctl enable catalogue &>>${LOG_FILE}
statusCheck $?