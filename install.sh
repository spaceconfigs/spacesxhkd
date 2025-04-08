#!/bin/bash

echo "-------------> Instalando SWHKD"
# $pminstall scrot
# $pminstall sxhkd

echo "-------------> Configurando SWHKD"
ln -sf $(pwd) ~/.config/sxhkd

killall -s SIGUSR1 sxhkd
