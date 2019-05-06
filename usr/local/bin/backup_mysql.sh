#!/bin/bash
echo "iniciando backup do banco mysql"
mysqldump -u root -pqaz123 --events --all-databases > /backup/backup_mysql.sql
if [ $? == 0 ] ; 
then
 echo "Concluido com sucesso!"
else
 echo "Backup falhou"
 exit 1
fi
