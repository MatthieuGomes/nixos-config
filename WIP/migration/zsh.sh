#!/usr/bin/env sh

OLD_SYSTEM_PATH=$1
USER=$2
SSH_ZSH_HIST_PATH=/home/$USER/.zsh_history

GROUP="users"

sudo rm -f $SSH_ZSH_HIST_PATH

sudo rsync -a $OLD_SYSTEM_PATH$SSH_ZSH_HIST_PATH $SSH_ZSH_HIST_PATH

sudo chown -R $USER:$GROUP $SSH_ZSH_HIST_PATH