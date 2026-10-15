# dotfiles

My terminal, shell and editor setup on Fedora KDE, managed with [chezmoi](https://www.chezmoi.io/). Everything uses the Gruvbox Material palette and Maple Mono NF.

This repo is a published subset of my private laptop bootstrap. Files get synced here by a script and nobody edits them in place, so expect commits to land in batches. Comments like `D-42` or `Q-5` point to decisions in the private repo's log. They explain why a line exists, and you can ignore them.

## What's inside

| Area | Files |
|---|---|
| Terminal | Ghostty, herdr (terminal multiplexer) |
| Shell | zsh with antidote, powerlevel10k (lean), fast-syntax-highlighting theme, fzf and `LS_COLORS` themes |
| Editors | Neovim (LazyVim), Zed, VS Code (settings and extension list), Sublime Text |
| CLI tools | bat, btop, atuin, lazygit, delta |
| Fonts | Maple Mono NF and Nerd Fonts Symbols, pinned by SHA-256 in `.chezmoiexternal.toml` |
| Claude Code | `settings.json` (theme, TUI, spinner verbs, env flags) and a two-line status line |

## Use it

Preview before you apply. Applying overwrites the matching files in your home directory.

```sh
chezmoi init r3cursive/dotfiles
chezmoi diff
chezmoi apply
```

Or copy just the file you want from `home/`. In chezmoi's naming, `dot_` becomes `.`, and `private_` and `executable_` only set permissions.

## Notes

- LAN and tailnet hosts are placeholders (`lan-host.lan`, `host.your-tailnet.ts.net`), and the local model ids are simplified. API keys never appear in the files: they come from 1Password via `op run` at launch.
- The Claude Code status line works on its own. It also reads optional session state from my LifeOS setup, and it skips those segments when the files don't exist.
