#!/bin/sh
# set -x
if [ -z $1 ] || [ -z $2 ] || [ -z $3 ] ; then
  echo "Erro: use $0 HostAddress Path_Datastore VM_name"
  echo " "
  echo "HostAddress = IP/DNS Address of the Vmware Server" 
  echo "Path_Datastore = Path where getthoVCB is installed"
  echo "VM_name = Virtual Machine's name"
  echo " "
  echo "Sample: $0 111.111.111.111 /vmfs/volumes/datastore1/backup/ CentOS7v3"
  exit 1
fi
HOSTADDR=$1
PATHDS=$2
VM=$3
SSH_PARAM="-i /etc/bacula/.ssh/id_dsa -o StrictHostKeyChecking=no -o Compression=yes -o CompressionLevel=9"
SSHFS_PARAM="-o StrictHostKeyChecking=no -o Compression=yes -o CompressionLevel=9"
# SSHFS_PARAM="-o IdentityFile=/etc/bacula/.ssh/id_dsa -o StrictHostKeyChecking=no -o Compression=yes -o CompressionLevel=9"
# SSH_PARAM="-o StrictHostKeyChecking=no -o Compression=yes -o CompressionLevel=9"
DEST="/home/vmware/${HOSTADDR}/${VM}"

# Running Backup ghettoVCB

echo -n "Running ghettoVCB on ${HOSTADDR}... "


ssh ${SSH_PARAM} root@${HOSTADDR} "${PATHDS}/ghettoVCB-master/ghettoVCB2.sh ${VM}"

if [ $? -eq 0 ]; then
  echo "OK"
else
  echo "Fail"
  exit 1
fi

# Check if exist directory

if ! [ -d $DEST ]; then
  mkdir -p $DEST
  echo "$DEST created"
fi

# Running SCP

echo -n "Mount ${PATHDS} from ${HOSTADDR} in ${DEST} ... "

sudo sshfs ${SSHFS_PARAM} root@${HOSTADDR}:${PATHDS}/${VM} ${DEST}

if [ $? -eq 0 ]; then
  echo "OK"
else
  echo "Fail"
  exit 2
fi


# Cleaning remote directory

echo -n "Cleaning remote direcoty ${PATHDS}/${VM}... "

ssh ${SSH_PARAM} root@${HOSTADDR} "rm -rf ${PATHDS}/${VM}"

if [ $? -eq 0 ]; then
  echo "OK";
else
  echo "Fail"
  exit 3
fi
