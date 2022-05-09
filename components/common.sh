checkRootUser(){

   USER_ID=$(id -u)

  if [ "$USER_ID" -ne "0" ]; then
    echo -e "\e[32myou are suppose to be running script as sudo or root user\e[0m"
    exit 1

  fi
}
