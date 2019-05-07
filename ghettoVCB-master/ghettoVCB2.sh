#!/bin/sh
if [ -z $1 ]; then
  echo "Erro: use $0 <VM_name>"
  exit 1
fi
DIR=/vmfs/volumes/datastore1  
DIR_EXEC=${DIR}/backup/ghettoVCB-master
DIR_TEMP=${DIR}/backup/temp
${DIR_EXEC}/ghettoVCB.sh -g ${DIR_EXEC}/ghettoVCB.conf -w ${DIR_TEMP} -m $1
