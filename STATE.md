# Stateful Directories

Directories containing data not managed by NixOS configuration.
Back these up separately.

## User Data
- `~/code/` - Source code and projects
- `~/Downloads/` - Downloaded files
- `~/Pictures/` - Screenshots and images

## Secrets & Keys
- `~/.secrets.env` - Environment secrets (API keys, tokens)
- `~/.ssh/` - SSH keys and config

## Application State
- `~/.local/share/` - Application data (databases, caches)
- `~/.cache/clipcat/` - Clipboard history
- `~/.npm-global/` - Global npm packages
- `~/.nvm/` - Node version manager

## System State
- `/var/lib/postgresql/` - PostgreSQL databases
- `/var/lib/docker/` - Docker images and volumes
