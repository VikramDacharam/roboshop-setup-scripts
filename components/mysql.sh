#!/usr/bin/env bash

source components/common.sh
checkRootUser

# systemctl enable mysqld
# systemctl start mysqld
# grep temp /var/log/mysqld.log
# mysql_secure_installation
# mysql -uroot -pRoboShop@1
# uninstall plugin validate_password;
# curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
# cd /tmp
# unzip mysql.zip
# cd mysql-main
# mysql -u root -pRoboShop@1 <shipping.sql

ECHO "setup mysql repo"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>${LOG_FILE}
statusCheck $?

ECHO "install mysql"
yum install mysql-community-server -y &>>${LOG_FILE}
statusCheck $?

ECHO "start mysql"
systemctl enable mysqld &>>${LOG_FILE} && systemctl start mysqld &>>${LOG_FILE}
statusCheck $?


Default_passwd=$( grep ' A temporary password ' /var/log/mysqld.log | awk '{print $NF}')
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'Roboshop@1';" >/tmp/root-pass.sql

echo show databases | mysql -uroot -pRoboShop@1 &>>${LOG_FILE}
if [ $? -ne 0 ]; then
  ECHO "Reset MYSQL Password"
mysql --connect-expired-password -u root -p${Default_passwd} </tmp/root-pass.sql &>>${LOG_FILE}
statusCheck $?
fi

echo 'show plugins;' |mysql -uroot -pRoboShop@1 2>>${LOG_FILE} | grep validate_password &>>${LOG_FILE}
if [ $? -eq 0 ]; then
ECHO "uninstall password plugin"
echo "uninstall plugin validate_password;" | mysql -uroot -pRoboShop@1 &>>${LOG_FILE}
statusCheck $?
fi

ECHO "Download schema"
cd /tmp
curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip" &>>{LOG_FILE} && unzip -o /tmp/mysql.zip &>>{LOG_FILE}
statusCheck $?

ECHO "Load schema"
cd /tmp/mysql-main
mysql -uroot -pRoboShop@1 <shipping.sql &>>${LOG_FILE}
statusCheck $?







