#!/bin/sh

set -eu

if ! command -v nixos-container &> /dev/null
then
    echo "Are you sure you're running NixOS?"
    exit 1
fi

nixos-container create --flake '.#rsync' rsync || nixos-container update --flake '.#rsync' rsync || "couldn't neither create container nor update it"
nixos-container create --flake '.#restic' restic || nixos-container update --flake '.#restic' restic || "couldn't neither create container nor update it"
nixos-container create --flake '.#duplicati' duplicati || nixos-container update --flake '.#duplicati' duplicati || "couldn't neither create container nor update it"
