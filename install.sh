#!/bin/bash

echo "-------------> Instalando SWHKD"
# $pminstall scrot
# $pminstall sxhkd

echo "-------------> Configurando SWHKD"
ln -sf $(pwd) ~/.config/swhkd

killall -s SIGUSR1 swhkd
