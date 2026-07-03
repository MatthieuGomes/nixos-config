#!/usr/bin/env sh

OLD_SYSTEM_PATH=$1
USER=$2
SSH_FOLDER_PATH=/home/$USER/.ssh

GROUP="users"

sudo rm -rf /home/$USER/.ssh/*

sudo rsync -a $OLD_SYSTEM_PATH$SSH_FOLDER_PATH/ $SSH_FOLDER_PATH/

sudo chown -R $USER:$GROUP $SSH_FOLDER_PATH