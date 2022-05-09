checkRootUser() {

USER_ID=$(id -u)

if [ "$User_ID" -ne "0" ]; then
  echo you are suppose to be running script as sudo or root checkRootUser
  exit

fi
}