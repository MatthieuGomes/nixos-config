#!/usr/bin/env sh

NEW_SYS_PART=$1
NEW_MNT_POINT=$2
NEW_BOOT_PART=$3
OLD_CONFIG_FOLDER=$4
NEW_USER=$5

sudo mount $NEW_SYS_PART $NEW_MNT_POINT
sudo mkdir ${NEW_MNT_POINT}/boot
sudo mount $NEW_BOOT_PART ${NEW_MNT_POINT}/boot
sudo mkdir ${NEW_MNT_POINT}/etc

sudo rsync -a ${OLD_CONFIG_FOLDER} ${NEW_MNT_POINT}/etc/
sudo nixos-generate-config --root ${NEW_MNT_POINT}
sudo nixos-install --root ${NEW_MNT_POINT} --flake ${NEW_MNT_POINT}/etc/nixos#NixOS --show-trace

sudo nixos-enter --root ${NEW_MNT_POINT} --command "passwd ${NEW_USER}"
sudo nixos-enter --root ${NEW_MNT_POINT} --command "chown -R ${NEW_USER}:users /etc/nixos/"