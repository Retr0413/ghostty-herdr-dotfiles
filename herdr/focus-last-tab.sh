#!/bin/sh
# Focus the rightmost Herdr tab.
#
# Herdr has no built-in "last tab" action (switch_tab only maps 1..9 to fixed
# positions), so this resolves the highest tab number over the socket API.
# Bound to prefix+0 in config.toml, which Ghostty sends on Cmd+9 to follow the
# macOS convention where Cmd+9 jumps to the last tab.
set -eu

herdr="$HOME/.local/bin/herdr"
[ -x "$herdr" ] || herdr=$(command -v herdr) || exit 0

tab_id=$("$herdr" tab list 2>/dev/null |
  /usr/bin/jq -r '.result.tabs | sort_by(.number) | last | .tab_id // empty')

[ -n "${tab_id:-}" ] || exit 0
exec "$herdr" tab focus "$tab_id"
