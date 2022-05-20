checkRootUser(){

   USER_ID=$(id -u)

  if [ "$USER_ID" -ne "0" ]; then
    echo -e "\e[32myou are suppose to be running script as sudo or root user\e[0m"
    exit 1

  fi
}


statusCheck(){
if [ $1 -eq 0 ]; then
  echo -e "\e[32mSuccess\e[0m"
else
  echo -e "\e[32mFailure\e[0m"

  echo "check the error in log in ${LOG_FILE} "

  exit 1
  fi

  }

  LOG_FILE=/tmp/roboshop.log
  rm -f $LOG_FILE

ECHO(){

  echo "===============$1===============" >>$LOG_FILE
  echo "$1"
}

NodeJs(){

ECHO "configure NodeJs Yum Repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
statusCheck $?

ECHO "Install nodejs"
yum install nodejs gcc-c++ -y &>>${LOG_FILE}
statusCheck $?

id roboshop &>>${LOG_FILE}

if [ $? -ne 0 ]; then
  ECHO "Add Application user"
  useradd roboshop &>>${LOG_FILE}
  statusCheck $?
fi

ECHO "download application content"
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip"
statusCheck $?

ECHO "Extract Application Archieve"
cd /home/roboshop && rm -rf ${COMPONENT} &>>${LOG_FILE} && unzip /tmp/${COMPONENT}.zip && mv ${COMPONENT}-main ${COMPONENT} &>>${LOG_FILE}
statusCheck $?

ECHO "Install NodeJs Modules"
cd /home/roboshop/${COMPONENT} && npm install &>>${LOG_FILE} && chown roboshop:roboshop /home/roboshop/${COMPONENT} -R
statusCheck $?

ECHO "update systemd configure files"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service
statusCheck $?

ECHO "setup systemd service"
mv /home/roboshop/${COMPONENT}/systemd.service  /etc/systemd/system/${COMPONENT}.service
 systemctl daemon-reload &>>${LOG_FILE} && systemctl enable ${COMPONENT} &>>${LOG_FILE} && systemctl restart ${COMPONENT} &>>${LOG_FILE}
statusCheck $?

}
