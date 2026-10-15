# theme-fzf.zsh — fzf colours. Managed by chezmoi (~/dev/bootstrap). Plan: docs/plans/20-terminal.md (v3).
# 25-colors §11 FINAL (Q-25.17): fzf uses the TERMINAL'S ANSI colours (no 24-bit theme), so it
# follows Ghostty's gruvbox-material-hard-fixed palette automatically.
# `base16` (alias `16`) is fzf's ANSI-only base scheme (fzf v0.74.4 man/man1/fzf.1 "BASE SCHEME";
# src/tui/tui.go Default16 uses only colors 0-15 + terminal default fg/bg). Without it, fzf picks
# the 256-colour "dark" scheme on xterm-256color terminals.
# Sourced by ~/.zshrc (Track A). fzf-tab only uses FZF_DEFAULT_OPTS with
# `zstyle ':fzf-tab:*' use-fzf-default-opts yes` (Track A, Q-B24).
# Q-B14 answer: colours only — fzf's stock layout/info/border are kept (no behaviour options).

# Idempotent: re-sourcing ~/.zshrc does not append twice.
if [[ $FZF_DEFAULT_OPTS != *'--color=base16'* ]]; then
  export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS:+$FZF_DEFAULT_OPTS }--color=base16"
fi
