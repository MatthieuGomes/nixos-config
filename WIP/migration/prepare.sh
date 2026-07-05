#!/usr/bin/env sh

sudo mkdir -p /mnt/OldNixOS
sudo mount $(findfs LABEL=NixOs) /mnt/OldNixOS