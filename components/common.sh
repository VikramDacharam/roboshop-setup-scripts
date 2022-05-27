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

Application_Setup() {

id roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
  ECHO "Add Application user"
  useradd roboshop &>>${LOG_FILE}
  statusCheck $?
fi

ECHO "download application content"
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>${LOG_FILE}
statusCheck $?


ECHO "Extract Application Archieve"
cd /home/roboshop && rm -rf ${COMPONENT} &>>${LOG_FILE} && unzip /tmp/${COMPONENT}.zip && mv ${COMPONENT}-main ${COMPONENT} &>>${LOG_FILE}
statusCheck $?
}

Systemd_setup(){
chown roboshop:roboshop /home/roboshop/${COMPONENT} -R
ECHO "update systemd configure files"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e "s/CARTENDPOINT/cart.roboshop.internal/" -e "s/DBHOST/mysql.roboshop.internal/" -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e "s/CARTHOST/cart.roboshop.internal/" -e 's/USERHOST/user.roboshop.internal/' -e 's/AMQPHOST/rabbitmq.roboshop.internal' /home/roboshop/${COMPONENT}/systemd.service
statusCheck $?

ECHO "setup systemd service"
mv /home/roboshop/${COMPONENT}/systemd.service  /etc/systemd/system/${COMPONENT}.service
 systemctl daemon-reload &>>${LOG_FILE} && systemctl enable ${COMPONENT} &>>${LOG_FILE} && systemctl restart ${COMPONENT} &>>${LOG_FILE}
statusCheck $?
}

NodeJs(){

ECHO "configure NodeJs Yum Repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
statusCheck $?

ECHO "Install nodejs"
yum install nodejs gcc-c++ -y &>>${LOG_FILE}
statusCheck $?

Application_Setup

ECHO "Install NodeJs Modules"
cd /home/roboshop/${COMPONENT} && npm install &>>${LOG_FILE} && chown roboshop:roboshop /home/roboshop/${COMPONENT} -R
statusCheck $?

Systemd_setup

}

Java(){

  ECHO "Install java and Maven"
  yum install maven -y &>>${LOG_FILE}

  Application_Setup

 ECHO "compile maven package"
 cd /home/roboshop/${COMPONENT} && mvn clean package &>>${LOG_FILE} && mv target/${COMPONENT}-1.0.jar ${COMPONENT}.jar &>>${LOG_FILE}
  statusCheck $?

Systemd_setup

}

Python(){

  ECHO " install python"
   yum install python36 gcc python3-devel -y &>>${LOG_FILE}

   Application_Setup

    ECHO "compile maven package"
    cd /home/roboshop/${COMPONENT} && pip3 install -r requirements.txt &>>${LOG_FILE}
     statusCheck $?

   Systemd_setup

}