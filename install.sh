#!/usr/bin/env bash
# Agent Board installer — 一行命令给你的项目装上「任务看板 + 历史记录」多 Agent 协同协议
#
#   curl -fsSL https://raw.githubusercontent.com/KAiLun-PAN/agent-board/main/install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/KAiLun-PAN/agent-board/main/install.sh | bash -s -- --lang en --all
#
# Options:
#   --lang zh|en      模板语言 / template language (default: zh)
#   --dir  <path>     目标项目目录 / target project dir (default: current dir)
#   --all             同时写入 Cursor / Copilot / Windsurf 规则文件 / also write Cursor, Copilot, Windsurf rules
#   --board <name>    看板文件名 / board file name (default: BOARD.md)
#   --history <name>  历史文件名 / history file name (default: HISTORY.md)
#   --uninstall       移除规则段落（保留看板与历史） / remove rule blocks (keeps BOARD/HISTORY)
#   -h, --help
set -euo pipefail

REPO_RAW="${AGENT_BOARD_RAW:-https://raw.githubusercontent.com/KAiLun-PAN/agent-board/main}"
LANG_CODE="zh"; DIR="."; ALL=0; UNINSTALL=0; BOARD="BOARD.md"; HISTORY="HISTORY.md"
BEGIN="<!-- AGENT_BOARD_RULE_v1"; END="<!-- /AGENT_BOARD_RULE_v1 -->"

while [ $# -gt 0 ]; do
  case "$1" in
    --lang) LANG_CODE="$2"; shift 2;;
    --dir) DIR="$2"; shift 2;;
    --all) ALL=1; shift;;
    --board) BOARD="$2"; shift 2;;
    --history) HISTORY="$2"; shift 2;;
    --uninstall) UNINSTALL=1; shift;;
    -h|--help) sed -n '2,16p' "$0" 2>/dev/null || true; exit 0;;
    *) echo "unknown option: $1" >&2; exit 1;;
  esac
done
case "$LANG_CODE" in zh|en) ;; *) echo "--lang must be zh or en" >&2; exit 1;; esac

c_ok=$'\033[32m'; c_dim=$'\033[2m'; c_hi=$'\033[1;31m'; c_off=$'\033[0m'
say() { printf '%s\n' "$*"; }
ok()  { printf '  %s✓%s %s\n' "$c_ok" "$c_off" "$*"; }
skip(){ printf '  %s·%s %s\n' "$c_dim" "$c_off" "$*"; }

mkdir -p "$DIR"; cd "$DIR"
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT

# Locate templates: local clone first, otherwise download from GitHub.
SELF_DIR=""
if [ -n "${BASH_SOURCE[0]:-}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
  SELF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi
fetch() { # fetch <relative path> <dest>
  if [ -n "$SELF_DIR" ] && [ -f "$SELF_DIR/$1" ]; then cp "$SELF_DIR/$1" "$2"
  else curl -fsSL "$REPO_RAW/$1" -o "$2"; fi
}

# strip_block <file>: remove an existing rule block (between markers) in place.
strip_block() {
  [ -f "$1" ] || return 0
  awk -v b="$BEGIN" -v e="$END" '
    index($0,b)==1 {skip=1; next}
    skip && index($0,e)==1 {skip=0; next}
    !skip {print}
  ' "$1" > "$1.agentboard.tmp" && mv "$1.agentboard.tmp" "$1"
}

# upsert_block <file> <rule file> [front-matter]
upsert_block() {
  local f="$1" rule="$2" front="${3:-}"
  local existed=0; [ -f "$f" ] && existed=1
  mkdir -p "$(dirname "$f")"
  if [ $existed -eq 1 ] && grep -qF "$BEGIN" "$f"; then
    strip_block "$f"; existed=2
  fi
  if [ ! -s "$f" ]; then
    { [ -n "$front" ] && printf '%s\n' "$front"; cat "$rule"; } > "$f"
  else
    # trim trailing blank lines, then append block
    { awk 'NF{for(i=0;i<n;i++)print ""; n=0; print; next}{n++}' "$f"; printf '\n'; cat "$rule"; } > "$f.agentboard.tmp"
    mv "$f.agentboard.tmp" "$f"
  fi
  case $existed in 0) ok "created $f";; 1) ok "appended rule → $f";; 2) ok "updated rule in $f";; esac
}

TARGETS=(AGENTS.md CLAUDE.md GEMINI.md)
if [ $ALL -eq 1 ] || [ -d .cursor ]; then TARGETS+=(.cursor/rules/agent-board.mdc); fi
if [ $ALL -eq 1 ] || [ -f .github/copilot-instructions.md ]; then TARGETS+=(.github/copilot-instructions.md); fi
if [ $ALL -eq 1 ] || [ -f .windsurfrules ]; then TARGETS+=(.windsurfrules); fi

if [ $UNINSTALL -eq 1 ]; then
  say "Agent Board · uninstall in $(pwd)"
  for f in "${TARGETS[@]}"; do
    if [ -f "$f" ] && grep -qF "$BEGIN" "$f"; then strip_block "$f"; ok "removed rule from $f"; fi
  done
  say "  ${c_dim}$BOARD / $HISTORY kept.${c_off}"
  exit 0
fi

say ""
say "${c_hi}■${c_off} Agent Board — 任务看板 + 历史记录 · multi-agent protocol"
say "  ${c_dim}project: $(pwd) · lang: $LANG_CODE${c_off}"
say ""

fetch "templates/$LANG_CODE/RULE.md"    "$TMP/RULE.md"
fetch "templates/$LANG_CODE/BOARD.md"   "$TMP/BOARD.md"
fetch "templates/$LANG_CODE/HISTORY.md" "$TMP/HISTORY.md"

TODAY="$(date +%Y-%m-%d)"
# custom file names → rewrite references inside the templates
for t in RULE BOARD HISTORY; do
  sed -e "s/{{DATE}}/$TODAY/g" -e "s/BOARD\.md/$BOARD/g" -e "s/HISTORY\.md/$HISTORY/g" "$TMP/$t.md" > "$TMP/$t.out"
done

if [ -f "$BOARD" ]; then skip "$BOARD exists, kept"; else cp "$TMP/BOARD.out" "$BOARD"; ok "created $BOARD"; fi
if [ -f "$HISTORY" ]; then skip "$HISTORY exists, kept"; else cp "$TMP/HISTORY.out" "$HISTORY"; ok "created $HISTORY"; fi

CURSOR_FRONT=$'---\ndescription: Agent Board multi-agent protocol (task board + history log)\nalwaysApply: true\n---'
for f in "${TARGETS[@]}"; do
  if [ "$f" = ".cursor/rules/agent-board.mdc" ]; then upsert_block "$f" "$TMP/RULE.out" "$CURSOR_FRONT"
  else upsert_block "$f" "$TMP/RULE.out"; fi
done

say ""
if [ "$LANG_CODE" = "zh" ]; then
  say "完成。现在让任意 Agent 开工前先读 ${c_hi}$BOARD${c_off}，收工后写 ${c_hi}$HISTORY${c_off}。"
  say "${c_dim}AGENTS.md → Codex / Cursor / 多数 Agent · CLAUDE.md → Claude Code · GEMINI.md → Gemini CLI / Antigravity${c_off}"
else
  say "Done. Every agent now reads ${c_hi}$BOARD${c_off} before work and logs to ${c_hi}$HISTORY${c_off} after."
  say "${c_dim}AGENTS.md → Codex / Cursor / most agents · CLAUDE.md → Claude Code · GEMINI.md → Gemini CLI / Antigravity${c_off}"
fi
