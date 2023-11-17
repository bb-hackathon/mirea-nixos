#!/usr/bin/env nu

# Run `nixos-install` from the flake
def "main install" [] {
  sudo nixos-install --flake .#mirea-nixos --root /mnt
}

# Format <disk>
def "main format" [disk: string] {
  sudo mkfs.fat -F 32 $'(disk)1'
  sudo mkfs.btrfs $'(disk)2'
}

def main [] {}
