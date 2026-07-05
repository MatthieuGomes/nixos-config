#!/usr/bin/env sh

sudo mkdir -p /mnt/NewNixOs

sudo mkfs.ext4 -L "NixOS" $(findfs LABEL=NixOS)
sudo mkfs.fat -F 32 -n "NBOOTLOADER" $(findfs LABEL=NBOOTLOADER)