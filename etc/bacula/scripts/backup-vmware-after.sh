#!/bin/sh
# set -x
if [ -z $1 ] || [ -z $2 ] ; then
  echo "Erro: use $0 HostAddress VM_name"
  echo " "
  echo "HostAddress = IP/DNS Address of the Vmware Server" 
  echo "VM_name = Virtual Machine's name"
  echo " "
  echo "Sample: $0 111.111.111.111 CentOS7v3"
  exit 1
fi
HOSTADDR=$1
VM=$2
#SSH_PARAM="-i /etc/bacula/.ssh/id_dsa -o StrictHostKeyChecking=no"
SSH_PARAM="-o StrictHostKeyChecking=no"
DEST="/home/vmware/${HOSTADDR}/${VM}"
echo -n "Clean $DEST... "
sudo rm -rf ${DEST}/${VM}*
if [ $? -eq 0 ]; then
  echo "OK..."
#  exit 0
else 
  echo "Fail"
  exit 1
fi

# Umount
sudo fusermount -u $DEST
if [ $? -eq 0 ]; then
  echo "OK..."
#  exit 0
else 
  echo "Fail"
  exit 1
fi
