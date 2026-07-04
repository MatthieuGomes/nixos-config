#!/usr/bin/env sh

OLD_SYSTEM_PATH=$1
BLUETOOTH_PATH=/var/lib/bluetooth
OLD_MAC_ADDRESS=$(basename $(sudo find $OLD_SYSTEM_PATH$BLUETOOTH_PATH -maxdepth 1 -mindepth 1 -type d))
NEW_MAC_ADDRESS=$(basename $(sudo find $BLUETOOTH_PATH -maxdepth 1 -mindepth 1 -type d))

sudo systemctl stop bluetooth.service

sudo rm -rf $BLUETOOTH_PATH/$NEW_MAC_ADDRESS/*

sudo rsync -a $OLD_SYSTEM_PATH$BLUETOOTH_PATH/$OLD_MAC_ADDRESS/ $BLUETOOTH_PATH/$NEW_MAC_ADDRESS/

FILES=$(sudo ls $BLUETOOTH_PATH/$NEW_MAC_ADDRESS/)
for FILE in $FILES; do 
    sudo chown -R root:root $BLUETOOTH_PATH/$NEW_MAC_ADDRESS/$FILE
done  

sudo systemctl restart bluetooth.service