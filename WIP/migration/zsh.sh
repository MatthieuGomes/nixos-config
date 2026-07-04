#!/usr/bin/env sh

OLD_SYSTEM_PATH=$1
USER=$2
ZSH_HIST_PATH=/home/$USER/.zsh_history

GROUP="users"

sudo rm -f $ZSH_HIST_PATH

sudo rsync -a $OLD_SYSTEM_PATH$ZSH_HIST_PATH $ZSH_HIST_PATH

sudo chown -R $USER:$GROUP $ZSH_HIST_PATH