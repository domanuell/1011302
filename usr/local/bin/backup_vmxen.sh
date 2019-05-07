#!/bin/bash
#===============================================================================
#
#          FILE:  backup_vmxen.sh
# 
#         USAGE:  ./backup_vmxen.sh VM_NAME
# 
#   DESCRIPTION:  
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  Para Restore use:
#                 xe vm-import filename=<diretorio_de_backup/vm_a_restaurar>
#===============================================================================
#

# Variaveis

DEST="/mnt/BACKUP/"

################################################################################
# Não editar a partir daqui...
################################################################################

# Verificando falta de argumento

if [ -z "${1}" ]
  then
    echo "Necessario nome da \"VM\" (entre aspas) como argumento!"
    exit 1
fi


time=$(date +%d-%m-%Y)
dirBack="${DEST}${1}"

# Criando diretorio de backup

echo "Verificando ambiente..."
if [ -e "${dirBack}" ]
  then
     echo "Diretorio de backup ${1} ja existe!"
else
     mkdir ${dirBack}
     echo "Diretorio ${1} criado com sucesso!"
fi

# Remove Backups Antigos

echo "Excluindo arquivo de backup ${1} antigo!"
if [ -e ${dirBack}/${1}_*.xva ]; then
        rm -rf ${dirBack}/${1}_*.xva
fi



#Criando snapshot. Necessario para nao parar a VM.

echo "Iniciando backup da VM ${1}..."
echo "${1} - Criando Snapshot"
ID=$(xe vm-snapshot vm=${1} new-name-label=${1}_${time} &&
        {
        logger -t "XenBackup" -s "${1} - Snapshot Criado com Sucesso"
        }||{
        logger -t "XenBackup" -s "${1} - ERRO em Criar Snapshot"
        echo 1
        })

#Checagem de erro.

if [ "$ID" == "1" ]
then
        exit 1
fi

#Transformar o Snapshot em VM.

echo "${1} - Transformando Snapshot em VM."
xe template-param-set is-a-template=false uuid=${ID} &&
        {
        logger -t "XenBackup" -s "${1} - VM Criada a partir do Spnashot"
        }||{
        logger -t "XenBackup" -s "${1} - ERRO em Transformar Snapshot em VM "
        exit 2
        }

#Exportando VM para o DIR de backup.

echo "${1} - Exportando ara DIR de Backup."
xe vm-export vm=${1}_${time} filename=${dirBack}/${1}_${time}.xva &&
        {
        logger -t "XenBackup" -s "${1} - OK VM Exportada para DIR de Backup"
        }||{
        logger -t "XenBackup" -s "${1} - ERRO ao Exportar VM para DIR de Backup"
        exit 3
        }

#Removendo Snapshot depois de exportar.

echo "${1} - Removendo Snapshot."
xe vm-uninstall vm=${1}_${time} force=true &&
        {
        logger -t "XenBackup" -s "${1} - Snapshot Removido com Sucesso"
        }||{
        logger -t "XenBackup" -s "${1} - ERRO em Remover Snapshot"
        exit 4
        }

echo "Backup da VM ${1} Realizado com sucesso!"
