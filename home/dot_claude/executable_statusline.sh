#!/usr/bin/env bash
# Compact two-line LifeOS status line (picked 2026-10-11, "Statusline Options" artifact):
#   line 1: directory  branch*  session-name  ascent-chip            Model · effort   (right-aligned)
#   line 2: ctx ▰▰▰▱▱▱▱▱▱▱ 37% · 5h 23% (↻ 2h10m) · 7d 41%
# Reads only Claude Code's stdin JSON plus two LifeOS state files; no network, writes nothing.
# ANSI-16 colors, so the terminal's Gruvbox Material palette supplies them. Narrow panes drop the
# lowest-priority segments instead of wrapping. Installed as a symlink from
# ~/.claude/LIFEOS/USER/CUSTOMIZATIONS/statusline.sh (USER tier: LifeOS updates never overwrite it).
export LC_ALL=C.UTF-8 GIT_OPTIONAL_LOCKS=0
in=$(cat)

IFS=$'\t' read -r model effort ctx cwd sid sname r5 r5at r7 < <(jq -r 'def int: if type == "number" then floor | tostring else "" end;
  [(.model.display_name // .model.id // ""), (.effort.level // ""),
  (.context_window.used_percentage | int), (.workspace.current_dir // .cwd // ""),
  (.session_id // ""), (.session_name // ""),
  (.rate_limits.five_hour.used_percentage | int), (.rate_limits.five_hour.resets_at | int),
  (.rate_limits.seven_day.used_percentage | int)] | map(if . == "" then "-" else . end) | @tsv' <<<"$in" 2>/dev/null)
for v in model effort ctx cwd sid sname r5 r5at r7; do [[ ${!v} == - ]] && printf -v "$v" ''; done

R=$'\e[0m' B=$'\e[1m' GRN=$'\e[32m' YEL=$'\e[33m' BLU=$'\e[34m' PUR=$'\e[35m' AQU=$'\e[36m' RED=$'\e[31m' DIM=$'\e[90m'
# COLUMNS is rarely exported to the status line command, so ask the tty; keep slack for wide glyphs and Claude's padding.
W=${COLUMNS:-$({ stty size </dev/tty; } 2>/dev/null | cut -d' ' -f2)}; [[ $W =~ ^[0-9]+$ ]] || W=80; W=$((W - 4))
STATE=$HOME/.claude/LIFEOS/MEMORY/STATE

# ── line 1 segments: (plain text for width math, colored text) ──
home_cwd=${cwd/#$HOME/\~}
dir=${home_cwd##*/}; [[ $home_cwd == "~" ]] && dir="~"
branch="" dirty=""
# cwd can be any directory, including an unpacked archive with a hostile .git/config: never let it run
# core.fsmonitor or hooks. (A configured clean filter can still run on racily-clean files during status.)
g() { git -c core.fsmonitor=false -c core.hooksPath=/dev/null -C "$cwd" "$@"; }
if [[ -n $cwd ]] && branch=$(g branch --show-current 2>/dev/null) && [[ -n $branch ]]; then
  [[ -n $(g status --porcelain --untracked-files=no 2>/dev/null | head -c1) ]] && dirty="*"
fi
if [[ -z $sname && -n $sid && -r $STATE/session-names.json ]]; then
  sname=$(jq -r --arg s "$sid" '.[$s] // empty' "$STATE/session-names.json" 2>/dev/null)
fi
asc=""
if [[ -n $sid && -r $STATE/work.json ]]; then
  asc=$(jq -r --arg s "$sid" '[.sessions[]? | select(.sessionUUID == $s and (.ascent | type) == "object")]
        | sort_by(.updatedAt // "") | last | if . == null then empty else "\(.ascent.icon // "") \(.ascent.label // "")" end' \
        "$STATE/work.json" 2>/dev/null)
fi

right_p="$model${effort:+ · $effort}"
right_c="$GRN$B$model$R${effort:+ $DIM·$R $YEL$effort$R}"

# Build left side, dropping low-priority segments until it fits next to the model.
build_left() {   # $1 = include session name, $2 = include ascent
  left_p="$dir" left_c="$BLU$dir$R"
  [[ -n $branch ]] && { left_p+="  $branch$dirty"; left_c+="  $PUR $branch$dirty$R"; }
  [[ $1 == 1 && -n $sname ]] && { left_p+="  $sname"; left_c+="  $AQU$sname$R"; }
  [[ $2 == 1 && -n $asc ]] && { left_p+="  $asc"; left_c+="  $DIM$asc$R"; }
}
for try in "1 1" "1 0" "0 0"; do
  build_left $try
  (( ${#left_p} + 2 + ${#right_p} <= W )) && break
done
gap=$(( W - ${#left_p} - ${#right_p} ))
if (( gap >= 2 )); then printf '%s%*s%s\n' "$left_c" "$gap" '' "$right_c"
else printf '%s  %s\n' "$left_c" "$right_c"; fi

# ── line 2: gauges ──
bar() {   # $1 = percent (may be fractional) → 10-cell bar colored by threshold
  local p=$1 n c on="" off="" i
  [[ $p =~ ^[0-9]+$ ]] || return 0
  (( p < 0 )) && p=0; (( p > 100 )) && p=100
  n=$(( (p + 5) / 10 ))
  if (( p >= 80 )); then c=$RED; elif (( p >= 50 )); then c=$YEL; else c=$GRN; fi
  for ((i = 0; i < 10; i++)); do if (( i < n )); then on+="▰"; else off+="▱"; fi; done
  printf '%s%s%s%s%s %s%%' "$c" "$on" "$DIM" "$off" "$R" "$p"
}
pct() { local p=$1 c=$GRN; [[ $p =~ ^[0-9]+$ ]] || return 0; (( p >= 80 )) && c=$RED || { (( p >= 50 )) && c=$YEL; }; printf '%s%s%%%s' "$c" "$p" "$R"; }
line2="${DIM}ctx$R "
if [[ -n $ctx ]]; then line2+=$(bar "$ctx"); else line2+="$DIM—$R"; fi
if [[ -n $r5 ]]; then
  line2+="  $DIM·$R  ${DIM}5h$R $(pct "$r5")"
  if (( W >= 50 )) && [[ $r5at =~ ^[0-9]+$ ]] && (( (left = r5at - $(date +%s)) > 0 )); then
    printf -v left '%dh%02dm' $((left / 3600)) $(((left % 3600) / 60))
    line2+=" $DIM(↻ $left)$R"
  fi
fi
(( W >= 44 )) && [[ -n $r7 ]] && line2+="  $DIM·$R  ${DIM}7d$R $(pct "$r7")"   # narrow panes: drop 7d, then the reset timer
printf '%s\n' "$line2"
