#!/usr/bin/env sh

SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")

OLD_SYSTEM_PATH=$1
USER=$2

CONNECTIONS_PATH="/etc/NetworkManager/system-connections"

if [[ $USER ]]; then 
    source $SCRIPT_DIR/kwallet.sh $OLD_SYSTEM_PATH $USER
fi

sudo rm -rf $CONNECTIONS_PATH/*

sudo rsync -a $OLD_SYSTEM_PATH/$CONNECTIONS_PATH/ $CONNECTIONS_PATH/

sudo chown -R root:root $CONNECTIONS_PATH

systemctl restart NetworkManager.service
