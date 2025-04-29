#!/bin/bash
# tome - make terminal note taking a reflex.
set -e

CMD=$1
shift || true

TOME_ROOT="${TOME_DIR:-$HOME/.tome}"
EDITOR_CMD="${EDITOR:-vim}"

ensure_dir() {
    mkdir -p "$(dirname "$1")"
}

open_file() {
    local file="$1"
    ensure_dir "$file"
    "$EDITOR_CMD" "$file"
}

open_dated_note() {
    local input_date="$*"
    local date_formatted
    if [[ -z "$input_date" ]]; then
        input_date="today"
    fi

    date_formatted="$(gdate --date="$input_date" +%Y-%m-%d 2>/dev/null)"
    local year month file
    year="$(gdate --date="$input_date" +%Y 2>/dev/null)"
    month="$(gdate --date="$input_date" +%m 2>/dev/null)"
    file="$TOME_ROOT/$year/$month/$date_formatted.md"
    open_file "$file"
}


open_named_note() {
  local path="$*"
  if [[ -z "$path" ]]; then
    echo "Error: note name required."
    exit 1
  fi

  local file="$TOME_ROOT/$path.md"
  open_file "$file"
}


list_recent_notes() {
  local count="${1:-10}"

  if find . -type f -name '*.md' -printf "%T@ %p\n" >/dev/null 2>&1; then
    # GNU find
    find "$TOME_ROOT" -type f -name '*.md' -printf "%T@ %p\n"
  else
    # BSD find
    find "$TOME_ROOT" -type f -name '*.md' -exec stat -f "%m %N" {} +
  fi |
    sort -n -r |
    head -n "$count" |
    while read -r timestamp filepath; do
      if [[ -n "$timestamp" && -n "$filepath" ]]; then
        if [[ "$DATE_CMD" == "gdate" ]]; then
          printf "%s  %s\n" "$(date -d @"${timestamp}" '+%b %d %H:%M')" "${filepath#$TOME_ROOT/}"
        else
          printf "%s  %s\n" "$(date -r "${timestamp}" '+%b %d %H:%M')" "${filepath#$TOME_ROOT/}"
        fi
      fi
    done
}

case "$CMD" in
  date)
    open_dated_note "$@"
    ;;
  note)
    open_named_note "$@"
    ;;
  recent)
    list_recent_notes "$@"
    ;;
  *)
    echo "Usage: $0 {date|note|recent} [args]"
    exit 1
    ;;
esac
