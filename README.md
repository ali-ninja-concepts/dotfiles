# NixOS Dotfiles

Personal NixOS configuration for desktop with i3wm and NVIDIA RTX 5080.

## Structure

```
dotfiles/
├── nixos/
│   ├── configuration.nix   # System: NVIDIA, i3, packages, fonts
│   ├── home.nix            # User: i3 config, zsh, kitty, picom
│   └── flake.nix           # Flake entry point
├── config/
│   ├── kitty/              # Kitty terminal config
│   └── nvim/               # Neovim config
├── scripts/                # Custom scripts
└── .env.example            # Secrets template
```

## First Install (VM or Fresh Machine)

```bash
# Boot NixOS installer
# Partition and mount drives to /mnt

# Generate hardware config
sudo nixos-generate-config --root /mnt

# Clone this repo
git clone https://github.com/YOUR_USERNAME/dotfiles.git /mnt/etc/nixos

# Keep the generated hardware-configuration.nix!
# Install
cd /mnt/etc/nixos
sudo nixos-install --flake .#nixos

# Reboot
reboot
```

## After First Boot

```bash
# Rebuild after config changes
sudo nixos-rebuild switch --flake /etc/nixos#nixos

# Rollback if something breaks
sudo nixos-rebuild switch --rollback

# Update system
sudo nixos-rebuild switch --flake /etc/nixos#nixos --upgrade
```

## Hardware

- GPU: NVIDIA RTX 5080 (proprietary drivers)
- Monitors: Auto-detected via `autorandr.sh`
  - Largest resolution = primary (ultrawide)
  - 2560x1080 = rotated right (vertical)
  - Others placed to the right

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

## Secrets

```bash
# Create from template
cp .env.example ~/.secrets.env
chmod 600 ~/.secrets.env

# Edit and add your keys
nvim ~/.secrets.env
```

Never commit `~/.secrets.env`!
