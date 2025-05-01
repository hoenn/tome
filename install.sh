#!/bin/bash
set -e

# -------------------------------
# Defaults
# -------------------------------
DEFAULT_TOME_ROOT="$HOME/.tome"
DEFAULT_BIN_DIR="$HOME/bin"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# -------------------------------
# Optional CLI flags
# -------------------------------
TOME_ROOT=""
BIN_DIR=""
AUTO_YES="false"

for arg in "$@"; do
  case "$arg" in
    --help|-h)
      echo "Usage: ./install.sh [--yes] [--tome-root=DIR] [--bin-dir=DIR]"
      echo
      echo "Options:"
      echo "  --yes             Run without any prompts"
      echo "  --tome-root=DIR   Directory to store your notes (default: ~/.tome)"
      echo "  --bin-dir=DIR     Where to install the 'tome' command (default: ~/bin)"
      exit 0
      ;;
    --yes|-y)
      AUTO_YES="true"
      ;;
    --tome-root=*)
      TOME_ROOT="${arg#--tome-root=}"
      ;;
    --bin-dir=*)
      BIN_DIR="${arg#--bin-dir=}"
      ;;
    *)
      echo "Unknown option: $arg"
      echo "Usage: install.sh [--yes|-y] [--tome-root=...] [--bin-dir=...]"
      exit 1
      ;;
  esac
done

# -------------------------------
# Prompt if not set
# -------------------------------
if [[ "$AUTO_YES" == "false" ]]; then
  read -rp "Enter Tome root directory [default: $DEFAULT_TOME_ROOT]: " input_tome
  read -rp "Where should I install the 'tome' command? [default: $DEFAULT_BIN_DIR]: " input_bin
fi

TOME_ROOT="${TOME_ROOT:-${input_tome:-$DEFAULT_TOME_ROOT}}"
BIN_DIR="${BIN_DIR:-${input_bin:-$DEFAULT_BIN_DIR}}"

echo "Using TOME_ROOT: $TOME_ROOT"
echo "Installing binary to: $BIN_DIR"

# -------------------------------
# Install tome
# -------------------------------
mkdir -p "$TOME_ROOT/.templates"
mkdir -p "$TOME_ROOT/notes"
mkdir -p "$BIN_DIR"
cp "$SCRIPT_DIR/tome" "$BIN_DIR/tome"
chmod +x "$BIN_DIR/tome"

echo "Installed tome to $BIN_DIR/tome"
echo "Created templates folder at $TOME_ROOT/.templates"

# -------------------------------
# Bash completion (optional)
# -------------------------------
COMPLETION_SRC="$SCRIPT_DIR/tome-completion.bash"
COMPLETION_DEST="$HOME/.bash_completion.d/tome"

if [[ -f "$COMPLETION_SRC" ]]; then
  mkdir -p "$(dirname "$COMPLETION_DEST")"
  cp "$COMPLETION_SRC" "$COMPLETION_DEST"
  echo "Bash completion installed to $COMPLETION_DEST"

  echo "To enable it, add this to your ~/.bashrc or ~/.bash_profile:"
  echo "  source $COMPLETION_DEST"
fi

# -------------------------------
# PATH Check
# -------------------------------
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
  echo "$BIN_DIR is not in your PATH."
  echo "Add this to your shell config:"
  echo "  export PATH=\"$BIN_DIR:\$PATH\""
fi

echo "Done!"
