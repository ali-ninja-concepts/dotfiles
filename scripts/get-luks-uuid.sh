#!/usr/bin/env bash
set -euo pipefail

echo "Detected LUKS devices:"
echo

lsblk -o NAME,TYPE,FSTYPE | awk '$2=="crypt" || $3=="crypto_LUKS"'

echo
echo "UUIDs (use the one with TYPE=crypto_LUKS):"
echo

blkid | grep crypto_LUKS || {
  echo "No LUKS devices found."
  exit 1
}

echo
echo "Copy the UUID above into configuration.nix:"
echo
echo 'boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/YOUR-UUID";'
