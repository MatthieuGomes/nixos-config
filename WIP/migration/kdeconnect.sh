#!/usr/bin/env sh

OLD_SYSTEM_PATH=$1
USER=$2
KDECONNECT=/home/$USER/.config/kdeconnect

GROUP="users"

sudo cp $KDECONNECT/config $KDECONNECT/../config-tmp

sudo rm -rf $KDECONNECT/*

sudo rsync -a $OLD_SYSTEM_PATH$KDECONNECT/ $KDECONNECT/
sudo rm $KDECONNECT/config
sudo mv $KDECONNECT/../config-tmp $KDECONNECT/config

sudo chown -R $USER:$GROUP $KDECONNECT

sudo systemctl restart home-manager-$USER.service