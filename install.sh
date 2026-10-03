#!/bin/sh
set -eu

if [ "$(uname -s)" != "Darwin" ]; then
  printf '%s\n' 'This setup targets macOS.' >&2
  exit 1
fi

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ghostty_source="$repo_dir/ghostty/config"
herdr_source="$repo_dir/herdr/config.toml"
ghostty_target="$HOME/Library/Application Support/com.mitchellh.ghostty/config"
herdr_target="$HOME/.config/herdr/config.toml"
herdr_bin="$HOME/.local/bin/herdr"
focus_last_tab_source="$repo_dir/herdr/focus-last-tab.sh"
focus_last_tab_target="$HOME/.local/bin/herdr-focus-last-tab"

backup_existing() {
  target=$1
  backup="$target.backup.$(date +%Y%m%d%H%M%S)"
  suffix=1
  while [ -e "$backup" ] || [ -L "$backup" ]; do
    backup="$target.backup.$(date +%Y%m%d%H%M%S).$suffix"
    suffix=$((suffix + 1))
  done
  mv "$target" "$backup"
  printf 'Backed up %s to %s\n' "$target" "$backup"
}

link_config() {
  source=$1
  target=$2
  mkdir -p "$(dirname "$target")"
  if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
    printf 'Already linked: %s\n' "$target"
    return
  fi
  if [ -e "$target" ] || [ -L "$target" ]; then
    backup_existing "$target"
  fi
  ln -s "$source" "$target"
  printf 'Linked %s -> %s\n' "$target" "$source"
}

if [ ! -x "$herdr_bin" ]; then
  installed_herdr=$(command -v herdr || true)
  if [ -z "$installed_herdr" ] || [ ! -x "$installed_herdr" ]; then
    printf '%s\n' 'Herdr is missing. Run: brew bundle --file=Brewfile' >&2
    exit 1
  fi
  mkdir -p "$(dirname "$herdr_bin")"
  if [ -e "$herdr_bin" ] || [ -L "$herdr_bin" ]; then
    backup_existing "$herdr_bin"
  fi
  ln -s "$installed_herdr" "$herdr_bin"
  printf 'Linked %s -> %s\n' "$herdr_bin" "$installed_herdr"
fi

link_config "$ghostty_source" "$ghostty_target"
link_config "$herdr_source" "$herdr_target"

# Cmd+9 (prefix+0) runs this helper, referenced from herdr/config.toml by a
# fixed path so the binding keeps working wherever the repo is cloned.
chmod +x "$focus_last_tab_source"
link_config "$focus_last_tab_source" "$focus_last_tab_target"

printf '%s\n' 'Done. Restart Ghostty to use the new configuration.'
