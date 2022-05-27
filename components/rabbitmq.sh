#!/usr/bin/env bash

source components/common.sh
checkRootUser

# yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y
# curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash

# yum install rabbitmq-server -y
# systemctl enable rabbitmq-server
# systemctl start rabbitmq-server
# rabbitmqctl add_user roboshop roboshop123
# rabbitmqctl set_user_tags roboshop administrator
# rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"

ECHO "setup yum repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${LOG_FILE}
statusCheck $?

ECHO "install rabbitmq& Erlang"
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm rabbitmq-server -y &>>${LOG_FILE}
statusCheck $?

ECHO "start rabbitmq server"
systemctl enable rabbitmq-server &>>${LOG_FILE} && systemctl start rabbitmq-server &>>${LOG_FILE}
statusCheck $?

rabbitmqctl list_users | grep roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
ECHO "create an application user"
rabbitmqctl add_user roboshop roboshop123 &>>${LOG_FILE}
statusCheck $?
fi

ECHO "setup application user permission"
rabbitmqctl set_user_tags roboshop administrator &>>${LOG_FILE} && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>{LOG_FILE}
statusCheck $?






