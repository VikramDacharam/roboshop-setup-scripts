checkRootUser(){

   USER_ID=$(id -u)

  if [ "$USER_ID" -ne "0" ]; then
    echo -e "\e[32myou are suppose to be running script as sudo or root checkRootUser\e[0m"
    exit

  fi
}
