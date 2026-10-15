# theme-lscolors.zsh — LS_COLORS from vivid. Managed by chezmoi (~/dev/bootstrap).
# Plan: docs/plans/20-terminal.md (v3). 25-colors §11 FINAL (Q-25.16): vivid upstream `gruvbox-dark`.
# vivid comes from mise (`"aqua:sharkdp/vivid" = "0.11.1"` in ~/.config/mise/config.toml).
# Overrides Fedora's /etc/profile.d/colorls.sh value. eza has no theme.yml, so it uses these
# file-kind colours too; ls, fzf-tab and zsh completion list-colors read the same variable.
#
# Cached so vivid is not forked on every shell start: the cache is regenerated only when it is
# missing/empty or older than the vivid executable or the mise config (a version bump there).
# Force a refresh: rm ~/.cache/zsh/ls_colors-gruvbox-dark
# Sourced by ~/.zshrc (Track A), BEFORE any `zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}`.

(( $+commands[vivid] )) || return 0

() {
  local theme=gruvbox-dark
  local cache=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/ls_colors-$theme
  local cfg=${XDG_CONFIG_HOME:-$HOME/.config}/mise/config.toml
  if [[ ! -s $cache || $commands[vivid] -nt $cache || $cfg -nt $cache ]]; then
    mkdir -p -- ${cache:h} || return
    if vivid generate $theme >| $cache.tmp.$$ 2>/dev/null && [[ -s $cache.tmp.$$ ]]; then
      mv -f -- $cache.tmp.$$ $cache
    else
      rm -f -- $cache.tmp.$$
    fi
  fi
  [[ -s $cache ]] && export LS_COLORS="$(<$cache)"
}
