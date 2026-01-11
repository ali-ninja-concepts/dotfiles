# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a NixOS flake-based system configuration for a desktop with i3 window manager, NVIDIA GPU, and LUKS full-disk encryption. The configuration manages both system-level settings and user environment via Home Manager.

## Common Commands

```bash
# Rebuild and switch to new configuration
sudo nixos-rebuild switch --flake /etc/nixos#nixos

# Rebuild with package updates
sudo nixos-rebuild switch --flake /etc/nixos#nixos --upgrade

# Update flake inputs
nix flake update

# Rollback to previous generation
sudo nixos-rebuild switch --rollback

# Test configuration without switching
sudo nixos-rebuild test --flake /etc/nixos#nixos
```

## Architecture

### Configuration Layers

1. **flake.nix** - Entry point defining inputs (nixpkgs unstable, home-manager) and outputs
2. **nixos/configuration.nix** - System-wide config: boot, NVIDIA drivers, services, system packages
3. **nixos/home.nix** - User config via Home Manager: i3, shell, terminal, editor, desktop apps
4. **hardware-configuration.nix** - Auto-generated hardware detection (do not edit manually)

### Key Directories

- `config/nvim/` - Neovim configuration (Kickstart.nvim-based, plugins in `lua/kickstart/plugins/`)
- `config/kitty/` - Kitty terminal configuration
- `scripts/` - Utility scripts (monitor setup, dmenu launcher, display switching)
- `nixos/pkgs/` - Custom Nix package definitions
- `bin/` - Custom binaries (mybar status bar)

### Module Relationships

```
flake.nix
├── imports configuration.nix (system)
│   └── imports hardware-configuration.nix
└── enables home-manager
    └── imports home.nix (user)
```

## Important Patterns

### Adding System Packages
Edit `nixos/configuration.nix` → `environment.systemPackages`

### Adding User Packages
Edit `nixos/home.nix` → `home.packages`

### i3 Configuration
All i3 settings are in `nixos/home.nix` under `xsession.windowManager.i3.config`:
- Keybindings: `config.keybindings`
- Startup apps: `config.startup`
- Status bar: uses custom `~/bin/mybar` binary

### Custom Packages
See `nixos/pkgs/opencode.nix` for pattern to add custom packages from external sources.

### Secrets
- Never commit `.env` files (use `.env.example` as template)
- User secrets loaded from `~/.secrets.env` at shell startup

## System Details

- **Display**: X11 with i3, LightDM auto-login
- **GPU**: NVIDIA proprietary drivers (modesetting enabled)
- **Audio**: PipeWire
- **Services**: PostgreSQL 16, Docker
- **Shell**: Zsh with Oh My Zsh
- **Encryption**: LUKS with TPM2 auto-unlock support
