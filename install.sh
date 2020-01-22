#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
echo "WSE must be installed by itself for compatibility and security reasons. It also works best on a fresh installation of Ubuntu. Type 'y' and enter to continue"
read confirm
if [ $confirm != "y" ]
then
echo "You need to enter 'y' in order to continue"
exit
fi
apt update
apt upgrade -y
apt install net-tools
if [  ou need to enter 'y' in order to continue"
exit
fi
apt update
apt upgrade -y
apt install net-tools

#if [ != "" ] -->netstat -l | grep http
#then
#echo "HTTP Server detected, can not install."
#exit
#fi
