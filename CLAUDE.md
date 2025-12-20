# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a dotfiles repository managed with GNU Stow. The root directory is structured so that running `stow .` from the repo root symlinks configuration files to `$HOME`.

## Key Commands

```bash
# Apply dotfiles (creates symlinks to $HOME)
stow .

# Install/update Nix packages defined in the flake
nix-setup   # alias for: nix profile upgrade nix || nix profile install ~/.config/nix

# Update environment (auto-runs on shell startup)
update_my_env   # pulls latest changes, runs stow, reloads shell
```

## Architecture

- **Stow-based deployment**: Files are symlinked from this repo to `$HOME`. The `.stow-local-ignore` file excludes VCS files and documentation from being symlinked.
- **Nix flake** (`.config/nix/flake.nix`): Declaratively manages development tools (neovim, tmux, fzf, ripgrep, etc.)
- **Zinit**: ZSH plugin manager that handles plugin installation and loading (configured in `.zshrc`)
- **NvChad**: Neovim configuration is a git submodule pointing to a separate repository

## Configuration Components

| Path | Purpose |
|------|---------|
| `.zshrc` | Main shell config with Zinit plugins, aliases, keybindings |
| `.config/nix/flake.nix` | Nix package definitions |
| `.config/tmux/tmux.conf` | Tmux with TPM plugins and Catppuccin theme |
| `.config/starship.toml` | Starship prompt with Catppuccin Mocha palette |
| `.config/alacritty/` | Terminal emulator settings |
| `.config/nvim/` | NvChad submodule |
| `.scripts/helpers.sh` | Shell helper functions (sourced by .zshrc) |

## Theme

Catppuccin Mocha is used across tmux, starship, and alacritty for consistent styling.
