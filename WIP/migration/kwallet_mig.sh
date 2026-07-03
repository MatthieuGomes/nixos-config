#!/usr/bin/env sh

USER=$1
OLD_SYSTEM_PATH=$2
GROUP="users"

KWALLETD_PATH="/home/$USER/.local/share/kwalletd"

sudo rm -rf $KWALLETD_PATH/*

sudo rsync -a $OLD_SYSTEM_PATH/$KWALLETD_PATH/ $KWALLETD_PATH/

sudo chown -R $USER:$GROUP $KWALLETD_PATH

kwalletmanager5