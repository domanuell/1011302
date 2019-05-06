#!/bin/bash
echo "limpando diretorio /backup"
rm -rf /backup/*
if [ $? == 0 ]; then
 echo "concluido"
else
 echo "falhou"
 exit 1
fi
