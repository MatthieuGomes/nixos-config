#!/usr/bin/env sh

SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")

OLD_SYSTEM_PATH=$1
NEED_WALLET=$2
USER=$3

GROUP="users"

CONNECTIONS_PATH="/etc/NetworkManager/system-connections"

if [[ "$NEED_WALLET" == "y" ]]; then 
    source $SCRIPT_DIR/kwallet.sh $USER $OLD_SYSTEM_PATH
fi

sudo rm -rf $CONNECTIONS_PATH/*

sudo rsync -a $OLD_SYSTEM_PATH/$CONNECTIONS_PATH/ $CONNECTIONS_PATH/

sudo chown -R root:root $CONNECTIONS_PATH

systemctl restart NetworkManager.service
