# NixOS Dotfiles

Personal NixOS configuration for desktop with i3wm and NVIDIA RTX 5080.

## Structure

```
dotfiles/
├── nixos/
│   ├── configuration.nix   # System: NVIDIA, i3, packages, fonts, TPM2
│   ├── home.nix            # User: i3 config, zsh, kitty, picom
│   └── flake.nix           # Flake entry point
├── config/
│   ├── kitty/              # Kitty terminal config
│   └── nvim/               # Neovim config
├── scripts/
│   ├── autorandr.sh        # Auto-detect and configure monitors
│   └── get-luks-uuid.sh    # Helper to get LUKS UUID for install
└── .env.example            # Secrets template
```

## Hardware

- GPU: NVIDIA RTX 5080 (proprietary drivers)
- Encryption: LUKS with TPM2 auto-unlock
- Dual-boot: Windows on separate SSD (no interference)
- Monitors: Auto-detected via `autorandr.sh`

---

## Installing NixOS (UEFI + LUKS + Flakes)

Official docs: https://nixos.org/manual/nixos/stable/#sec-installation

### Prerequisites

- UEFI system with TPM2
- NixOS graphical ISO on USB
- Empty SSD for NixOS (Windows stays on its own SSD)

### 1. Create Installation Media

Download: https://nixos.org/download.html

Flash using [Balena Etcher](https://www.balena.io/etcher/) or:

```bash
sudo dd bs=4M conv=fsync oflag=direct status=progress if=nixos.iso of=/dev/sdX
```

Boot in **UEFI mode** (disable Secure Boot for now).

### 2. Boot Installer & Get Root Shell

```bash
sudo -i
```

Verify networking:

```bash
ip a
```

For Wi-Fi:

```bash
nmtui
```

### 3. Identify Your NixOS Disk

```bash
lsblk
```

Find the SSD for NixOS (NOT your Windows drive).
Example: `/dev/nvme0n1` (adjust commands below accordingly).

### 4. Partition Disk (UEFI + LUKS)

**This erases the target disk completely.**

```bash
parted /dev/nvme0n1 -- mklabel gpt
parted /dev/nvme0n1 -- mkpart ESP fat32 1MB 1GB
parted /dev/nvme0n1 -- set 1 esp on
parted /dev/nvme0n1 -- mkpart primary 1GB 100%
```

### 5. Setup LUKS Encryption

```bash
cryptsetup luksFormat /dev/nvme0n1p2
```

Enter a **strong passphrase** (you'll need this for recovery).

```bash
cryptsetup open /dev/nvme0n1p2 cryptroot
```

### 6. Format & Mount

```bash
mkfs.fat -F 32 -n BOOT /dev/nvme0n1p1
mkfs.ext4 -L nixos /dev/mapper/cryptroot

mount /dev/mapper/cryptroot /mnt
mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
```

### 7. Generate Hardware Config

```bash
nixos-generate-config --root /mnt
```

This creates `/mnt/etc/nixos/hardware-configuration.nix` (don't edit it).

### 8. Clone This Repo

```bash
git clone https://github.com/ali-zahir/dotfiles.git /mnt/etc/nixos
```

### 9. Get LUKS UUID

```bash
chmod +x /mnt/etc/nixos/scripts/get-luks-uuid.sh
/mnt/etc/nixos/scripts/get-luks-uuid.sh
```

Output:

```
/dev/nvme0n1p2: UUID="a1b2c3d4-e5f6-..." TYPE="crypto_LUKS"
```

### 10. Update Configuration

```bash
nano /mnt/etc/nixos/nixos/configuration.nix
```

Find and replace `YOUR-LUKS-UUID-HERE`:

```nix
boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/a1b2c3d4-e5f6-...";
```

### 11. Install

```bash
cd /mnt/etc/nixos
nixos-install --flake .#nixos
```

Set root password when prompted.

### 12. Reboot

```bash
reboot
```

Remove USB. Enter LUKS passphrase at boot.

---

## After First Boot

### Rebuild System

```bash
sudo nixos-rebuild switch --flake /etc/nixos#nixos
```

### Rollback If Needed

```bash
sudo nixos-rebuild switch --rollback
```

### Update System

```bash
sudo nixos-rebuild switch --flake /etc/nixos#nixos --upgrade
```

---

## TPM2 Auto-Unlock (No Password on Boot)

After your system is working with passphrase unlock, you can enable TPM2 auto-unlock.

### How It Works

- TPM2 stores a sealed secret
- Secret unlocks LUKS automatically on boot
- If anything changes (BIOS update, Secure Boot toggle), passphrase is required
- Your passphrase **always works as fallback**

### Prerequisites

- System boots successfully with LUKS passphrase
- TPM2 chip present (most modern systems have this)

### Step 1: Verify TPM2 Is Available

```bash
ls /dev/tpm*
```

Should show `/dev/tpm0` or `/dev/tpmrm0`.

### Step 2: Enroll TPM2 Key

Run this **once** after system is working:

```bash
sudo systemd-cryptenroll \
  --tpm2-device=auto \
  --tpm2-pcrs=7 \
  /dev/disk/by-uuid/YOUR-LUKS-UUID
```

- `--tpm2-pcrs=7` ties unlock to Secure Boot state
- Enter your existing LUKS passphrase when prompted

### Step 3: Reboot & Test

```bash
reboot
```

System should unlock automatically (no password prompt).

### If TPM Unlock Fails

You'll see the passphrase prompt. Enter your password — system boots normally.

This happens when:
- BIOS/firmware was updated
- Secure Boot state changed
- Boot chain was modified

After booting, re-enroll TPM if needed.

### Remove TPM Enrollment (If Needed)

```bash
sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/disk/by-uuid/YOUR-LUKS-UUID
```

---

## Dual-Boot Notes (Windows on Separate SSD)

- Windows uses its own TPM keys (BitLocker)
- NixOS uses its own LUKS TPM slot
- They **do not interfere** with each other
- No changes needed on the Windows side
- Boot menu: use BIOS boot selector (F12/F8/etc.) or systemd-boot

---

## Recovery

### Boot From Live USB

```bash
cryptsetup open /dev/nvme0n1p2 cryptroot
mount /dev/mapper/cryptroot /mnt
mount /dev/nvme0n1p1 /mnt/boot
nixos-enter
```

### Reset TPM Enrollment

```bash
sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/disk/by-uuid/YOUR-LUKS-UUID
```

### Re-Enroll TPM After Changes

```bash
sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/disk/by-uuid/YOUR-LUKS-UUID
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 /dev/disk/by-uuid/YOUR-LUKS-UUID
```

---

## Key Bindings (i3)

| Key | Action |
|-----|--------|
| `Alt+Return` | Terminal (kitty) |
| `Alt+d` | Dmenu launcher |
| `Alt+q` | Kill window |
| `Alt+f` | Fullscreen |
| `Alt+h/v` | Split horizontal/vertical |
| `Alt+1-0` | Switch workspace |
| `Alt+Shift+1-0` | Move to workspace |
| `Alt+Shift+s` | Screenshot (selection) |
| `Alt+Tab` | Previous workspace |
| `Alt+Shift+c` | Reload i3 |
| `Alt+Shift+r` | Restart i3 |
| `Alt+r` | Resize mode |
| `Alt+[/]` | Brightness -/+ |
| `Alt+Shift+[/]` | Volume -/+ |

---

## Secrets

```bash
cp .env.example ~/.secrets.env
chmod 600 ~/.secrets.env
nvim ~/.secrets.env
```

Never commit `~/.secrets.env`!
