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
2. **nixos/configuration.nix** - Imports all system modules
3. **nixos/home.nix** - Imports all home-manager modules
4. **hardware-configuration.nix** - Auto-generated hardware detection (do not edit manually)

### Directory Structure

```
/etc/nixos/
├── flake.nix                     # Flake entry point
├── hardware-configuration.nix    # Auto-generated (don't edit)
├── STATE.md                      # Documents stateful directories
├── nixos/
│   ├── configuration.nix         # System module imports
│   ├── home.nix                  # Home module imports
│   ├── modules/
│   │   ├── system/
│   │   │   ├── boot.nix          # Boot, LUKS, TPM
│   │   │   ├── nvidia.nix        # GPU drivers, graphics
│   │   │   ├── audio.nix         # PipeWire
│   │   │   ├── networking.nix    # NetworkManager, locale
│   │   │   └── nix.nix           # Flakes, GC, optimise
│   │   ├── services/
│   │   │   ├── postgres.nix      # PostgreSQL 16
│   │   │   ├── docker.nix        # Docker
│   │   │   └── display.nix       # LightDM, i3, keyring
│   │   ├── users.nix             # User accounts
│   │   ├── packages.nix          # System packages
│   │   └── fonts.nix             # Font packages
│   ├── home/
│   │   ├── i3.nix                # i3 config, keybindings
│   │   ├── picom.nix             # Compositor
│   │   ├── shell.nix             # Zsh, aliases
│   │   ├── programs.nix          # Kitty, git, neovim, direnv
│   │   ├── packages.nix          # User packages
│   │   └── services.nix          # Clipcat, scripts
│   └── pkgs/
│       └── opencode.nix          # Custom package definitions
├── scripts/                      # Utility scripts
├── bin/                          # Custom binaries (mybar)
└── config/nvim/                  # Neovim configuration
```

## Important Patterns

### Adding System Packages
Edit `nixos/modules/packages.nix` → `environment.systemPackages`

### Adding User Packages
Edit `nixos/home/packages.nix` → `home.packages`

### i3 Configuration
Edit `nixos/home/i3.nix`:
- Keybindings: `config.keybindings`
- Startup apps: `config.startup`
- Status bar: uses custom `~/bin/mybar` binary

### Adding a New System Module
1. Create file in `nixos/modules/` (e.g., `modules/services/newservice.nix`)
2. Add import to `nixos/configuration.nix`

### Adding a New Home Module
1. Create file in `nixos/home/` (e.g., `home/newapp.nix`)
2. Add import to `nixos/home.nix`

### Custom Packages
See `nixos/pkgs/opencode.nix` for pattern to add custom packages from external sources.

### Secrets
- Never commit `.env` files (use `.env.example` as template)
- User secrets loaded from `~/.secrets.env` at shell startup

### Stateful Directories
See `STATE.md` for directories containing data not managed by Nix (code, downloads, secrets, databases).

## System Details

- **Display**: X11 with i3, LightDM auto-login
- **GPU**: NVIDIA proprietary drivers (modesetting enabled)
- **Audio**: PipeWire
- **Services**: PostgreSQL 16, Docker
- **Shell**: Zsh with Oh My Zsh
- **Encryption**: LUKS with TPM2 auto-unlock support
- **Maintenance**: Monthly garbage collection, automatic store optimization
