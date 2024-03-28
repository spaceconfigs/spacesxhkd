#!/bin/bash

echo "-------------> Instalando SXHKD"
# $pminstall scrot
# $pminstall sxhkd

echo "-------------> Configurando SXHKD"
ln -sf $(pwd) $HOME/.config/sxhkd

killall -s SIGUSR1 sxhkd
