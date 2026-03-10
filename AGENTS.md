# Neovim config (submodule)

## Scope

This file applies to everything under `nvim/`.

## What this is

- `nvim/` is a git submodule (see `.gitmodules`) and is symlinked into `~/.config/nvim` by home-manager (see `nixos/configuration.nix`).
- Entry point: `nvim/init.lua`.
- Structure:
  - `nvim/lua/options.lua`: core options and globals.
  - `nvim/lua/keymaps.lua`: keymaps + a few small autocmds.
  - `nvim/lua/lazy-bootstrap.lua`: bootstraps `folke/lazy.nvim` (clones on first start).
  - `nvim/lua/lazy-plugins.lua`: plugin list; mix of `kickstart.plugins.*` and `custom.plugins.*` modules.
  - `nvim/lua/kickstart/plugins/*`: upstream-style plugin modules.
  - `nvim/lua/custom/plugins/*`: local custom plugins and tweaks.
  - `nvim/lazy-lock.json`: lockfile for plugin versions.

## Conventions

- Lua formatting: run `stylua` using `nvim/.stylua.toml`.
- Keep changes minimal and aligned with the existing style (mostly single quotes, 2-space indent).

## Plugin management

- Plugins are managed with `lazy.nvim`.
- When changing plugin specs, expect `nvim/lazy-lock.json` to update.
- `nvim/lua/lazy-bootstrap.lua` does a `git clone` of `lazy.nvim` on first run; avoid breaking this path.

## Submodule hygiene

- Because `nvim/` is a submodule, avoid broad refactors/renames unless explicitly requested.
- Prefer edits inside `nvim/lua/custom/` for local behavior changes.
