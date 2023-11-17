#!/usr/bin/env bash
git clone https://github.com/mirea-nixos
cd mirea-nixos
sudo mount -o subvol=@ /dev/vda2 /mnt
sudo mount /dev/vda1 /mnt/boot
