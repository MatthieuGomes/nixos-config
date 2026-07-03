#!/usr/bin/env sh

USER=$1
NEW_SYSTEM_PATH=$2
GROUP="users"

KWALLETD_PATH="/home/$USER/.local/share/kwalletd"


FILES="$KWALLETD_PATH/kdewallet.kwl $KWALLETD_PATH/kdewallet.salt $KWALLETD_PATH/kdewallet_attributes.json"

sudo mkdir -p $NEW_SYSTEM_PATH$KWALLETD_PATH

sudo rm -rf $NEW_SYSTEM_PATH$KWALLETD_PATH/*

sudo cp -r $FILES $NEW_SYSTEM_PATH$KWALLETD_PATH

sudo nixos-enter --root $NEW_SYSTEM_PATH --command "chown -R $USER:$GROUP $KWALLETD_PATH && chmod 755 $KWALLETD_PATH && chmod 600 $FILES && chmod 644 $KWALLETD_PATH/kdewallet.*"