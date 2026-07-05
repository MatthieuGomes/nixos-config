#!/usr/bin/env sh

OLD_SYSTEM_PATH=$1
USER=$2
GROUP="users"

KWALLETD_PATH="/home/$USER/.local/share/kwalletd"

sudo rm -rf $KWALLETD_PATH/*

sudo rsync -a $OLD_SYSTEM_PATH/$KWALLETD_PATH/ $KWALLETD_PATH/

sudo chown -R $USER:$GROUP $KWALLETD_PATH

sudo kill $(pgrep kwalletd6)
sudo kill $(pgrep ksecretd)

qdbus org.kde.kwalletd6 /modules/kwalletd6 open kdewallet "" 0 > /dev/null