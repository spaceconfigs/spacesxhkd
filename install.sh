#!/bin/bash

echo "-------------> Instalando SXHKD"
# $pminstall scrot
# $pminstall sxhkd

echo "-------------> Configurando SXHKD"
mkdir -p $HOME/.config/sxhkd
ln -sf $(pwd)/SXHKD/* $HOME/.config/sxhkd/

killall -s SIGUSR1 sxhkd
