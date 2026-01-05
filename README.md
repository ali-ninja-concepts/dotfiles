# NixOS Dotfiles

Personal NixOS configuration for a desktop with i3 window manager and NVIDIA GPU.

## Why This Exists

NixOS is different from traditional Linux distributions. Instead of installing packages and editing config files scattered across the system, everything is declared in a few files. If something breaks, you can roll back in seconds. If you reinstall, you get the exact same system.

This repo captures a working desktop setup:
- Encrypted disk (LUKS) so your data is protected if the machine is stolen
- Optional TPM2 auto-unlock so you don't type a password every boot
- i3 window manager with sensible defaults
- NVIDIA drivers configured correctly (this is notoriously tricky on Linux)

The installation steps are written for someone who hasn't used NixOS before. You don't need to understand Nix to get this running.

## What You Get

After installation:

- Encrypted NixOS system (LUKS)
- i3 window manager with dmenu, i3status, picom compositor
- Kitty terminal with JetBrains Mono font
- Zsh with Oh My Zsh (dpoggi theme)
- NVIDIA proprietary drivers (tested with RTX 5080)
- Auto-detecting multi-monitor setup
- Common dev tools: git, neovim, nodejs, go, bun
- Modern CLI tools: eza, bat, fzf, ripgrep

## Repository Layout

```
dotfiles/
├── nixos/
│   ├── configuration.nix   # System config (packages, drivers, users)
│   ├── home.nix            # User config (i3, shell, apps)
│   └── flake.nix           # Entry point for the flake
├── config/                 # App configs (kitty, nvim)
├── scripts/
│   ├── autorandr.sh        # Auto-detect and arrange monitors
│   └── get-luks-uuid.sh    # Helper to find your LUKS UUID
└── .env.example            # Template for secrets
```

## Requirements

- UEFI system (not legacy BIOS)
- NVIDIA GPU (config uses proprietary drivers)
- TPM2 chip (optional, for auto-unlock)
- Empty SSD for NixOS (Windows can stay on a separate drive)

## Installation

This follows the [official NixOS installation guide](https://nixos.org/manual/nixos/stable/#sec-installation) with LUKS encryption added.

### Step 1: Create Installation USB

Download the NixOS graphical ISO from https://nixos.org/download.html

Flash it to a USB drive:
```bash
sudo dd bs=4M conv=fsync oflag=direct status=progress if=nixos.iso of=/dev/sdX
```

Boot from the USB in UEFI mode. Disable Secure Boot in your BIOS if needed.

### Step 2: Open a Terminal

Once the installer loads, open a terminal and get root:
```bash
sudo -i
```

Check networking:
```bash
ip a
```

For Wi-Fi, use `nmtui`.

### Step 3: Identify Your Disk

```bash
lsblk
```

Find the SSD where you want NixOS. In this guide, we'll use `/dev/nvme0n1`. Adjust if yours is different.

Do not touch your Windows drive if you're dual-booting.

### Step 4: Partition the Disk

This erases everything on the target disk.

```bash
parted /dev/nvme0n1 -- mklabel gpt
parted /dev/nvme0n1 -- mkpart ESP fat32 1MB 1GB
parted /dev/nvme0n1 -- set 1 esp on
parted /dev/nvme0n1 -- mkpart primary 1GB 100%
```

### Step 5: Set Up Encryption

Create the encrypted container:
```bash
cryptsetup luksFormat /dev/nvme0n1p2
```

You'll be asked for a passphrase. Choose something strong. This is your recovery key if TPM unlock ever fails.

Open the encrypted container:
```bash
cryptsetup open /dev/nvme0n1p2 cryptroot
```

### Step 6: Format and Mount

```bash
mkfs.fat -F 32 -n BOOT /dev/nvme0n1p1
mkfs.ext4 -L nixos /dev/mapper/cryptroot

mount /dev/mapper/cryptroot /mnt
mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
```

### Step 7: Generate Hardware Config

```bash
nixos-generate-config --root /mnt
```

This creates `/mnt/etc/nixos/hardware-configuration.nix`. Don't edit this file.

### Step 8: Clone This Repository

```bash
git clone https://github.com/ali-zahir/dotfiles.git /mnt/etc/nixos
```

### Step 9: Get Your LUKS UUID

```bash
chmod +x /mnt/etc/nixos/scripts/get-luks-uuid.sh
/mnt/etc/nixos/scripts/get-luks-uuid.sh
```

You'll see output like:
```
/dev/nvme0n1p2: UUID="a1b2c3d4-e5f6-7890-abcd-ef1234567890" TYPE="crypto_LUKS"
```

Copy the UUID (the part in quotes).

### Step 10: Update Configuration

```bash
nano /mnt/etc/nixos/nixos/configuration.nix
```

Find this line:
```nix
device = "/dev/disk/by-uuid/YOUR-LUKS-UUID-HERE";
```

Replace `YOUR-LUKS-UUID-HERE` with your actual UUID.

### Step 11: Install

```bash
cd /mnt/etc/nixos
nixos-install --flake .#nixos
```

Set the root password when prompted.

### Step 12: Reboot

```bash
reboot
```

Remove the USB. Enter your LUKS passphrase when prompted.

You now have a working NixOS system.

## After Installation

### Rebuild After Changes

```bash
sudo nixos-rebuild switch --flake /etc/nixos#nixos
```

### Update System

```bash
sudo nixos-rebuild switch --flake /etc/nixos#nixos --upgrade
```

### Rollback If Something Breaks

```bash
sudo nixos-rebuild switch --rollback
```

Or select a previous generation from the boot menu.

## TPM2 Auto-Unlock (Optional)

By default, you'll type your LUKS passphrase every boot. TPM2 auto-unlock removes this step while keeping your disk encrypted.

How it works:
- The TPM chip stores a secret tied to your system's boot state
- If the system boots normally, the TPM releases the secret and unlocks the disk
- If anything changes (BIOS update, different boot device), the TPM refuses and you use your passphrase instead

Your passphrase always works as a fallback.

### Enable TPM Auto-Unlock

First, verify TPM is available:
```bash
ls /dev/tpm*
```

You should see `/dev/tpm0` or `/dev/tpmrm0`.

Enroll the TPM:
```bash
sudo systemd-cryptenroll \
  --tpm2-device=auto \
  --tpm2-pcrs=7 \
  /dev/disk/by-uuid/YOUR-LUKS-UUID
```

Replace `YOUR-LUKS-UUID` with your actual UUID. Enter your LUKS passphrase when prompted.

Reboot:
```bash
reboot
```

The system should unlock automatically.

### If Auto-Unlock Fails

You'll see the passphrase prompt. Enter your password and the system boots normally.

This happens after:
- BIOS/firmware updates
- Secure Boot changes
- Boot chain modifications

To fix, re-enroll the TPM after booting:
```bash
sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/disk/by-uuid/YOUR-LUKS-UUID
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 /dev/disk/by-uuid/YOUR-LUKS-UUID
```

### Remove TPM Enrollment

```bash
sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/disk/by-uuid/YOUR-LUKS-UUID
```

## Dual-Boot with Windows

If you have Windows on a separate SSD:
- Windows uses its own TPM keys (BitLocker)
- NixOS uses its own LUKS TPM slot
- They don't interfere with each other
- Use your BIOS boot menu (F12/F8/etc.) to switch between them

No changes needed on the Windows side.

## Desktop Usage

### i3 Key Bindings

| Key | Action |
|-----|--------|
| `Alt+Return` | Open terminal |
| `Alt+d` | App launcher (dmenu) |
| `Alt+q` | Close window |
| `Alt+f` | Fullscreen |
| `Alt+h` | Split horizontal |
| `Alt+v` | Split vertical |
| `Alt+1-0` | Switch workspace |
| `Alt+Shift+1-0` | Move window to workspace |
| `Alt+Shift+s` | Screenshot (selection) |
| `Alt+Tab` | Previous workspace |
| `Alt+Shift+c` | Reload i3 config |
| `Alt+Shift+r` | Restart i3 |
| `Alt+[/]` | Brightness down/up |
| `Alt+Shift+[/]` | Volume down/up |

### Monitors

Monitors are auto-detected on login. The script:
- Sets the largest resolution display as primary
- Rotates 2560x1080 ultrawide monitors vertically
- Arranges others to the right

To customize, edit `scripts/autorandr.sh`.

### Shell Aliases

| Alias | Command |
|-------|---------|
| `ls` | eza |
| `ll` | eza -la |
| `cat` | bat |
| `rebuild` | sudo nixos-rebuild switch |
| `update` | sudo nixos-rebuild switch --upgrade |
| `copy` | copy to clipboard |
| `p` | paste from clipboard |

## Recovery

### Boot from Live USB

If you can't boot normally:

```bash
cryptsetup open /dev/nvme0n1p2 cryptroot
mount /dev/mapper/cryptroot /mnt
mount /dev/nvme0n1p1 /mnt/boot
nixos-enter
```

Now you're in your installed system and can fix things.

### Reset TPM Enrollment

```bash
sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/disk/by-uuid/YOUR-LUKS-UUID
```

Then re-enroll if desired.

## Secrets

Copy the example file and add your secrets:
```bash
cp .env.example ~/.secrets.env
chmod 600 ~/.secrets.env
```

This file is sourced by zsh on login. Never commit it.

## Customization

- **Packages**: Edit `nixos/configuration.nix` (system-wide) or `nixos/home.nix` (user)
- **i3 config**: Edit the `xsession.windowManager.i3` section in `home.nix`
- **Shell**: Edit `programs.zsh` in `home.nix`
- **Monitors**: Edit `scripts/autorandr.sh`

After changes, run `rebuild` to apply.
