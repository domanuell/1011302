#!/bin/sh
#
# Script para criar o arquivo de configuracao de restore
#
VM=$1
if [ -z $1 ] ; then
  echo "Erro use $0 <VM_name>"
  exit 1
fi
    
    
DIR_ORIG=/vmfs/volumes/datastore1/backup/$VM/
LS=`ls -1 $DIR_ORIG`
DIR_DEST=/vmfs/volumes/datastore1/
echo "\"${DIR_ORIG}${LS};${DIR_DEST};3;${LS}\"" > ${DIR_DEST}/backup/ghettoVCB-master/ghettoVCB-restore.conf
    
    
${DIR_DEST}/backup/ghettoVCB-master/ghettoVCB-restore.sh -c ${DIR_DEST}/backup/ghettoVCB-master/ghettoVCB-restore.conf
