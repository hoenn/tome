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
# Git repo (optional)
# -------------------------------
if command -v git >/dev/null 2>&1; then
  if [[ ! -d "$TOME_ROOT/.git" ]]; then
    if [[ "$AUTO_YES" == "false" ]]; then
      read -rp "Would you like to initialize a git repo in $TOME_ROOT? [y/N]: " git_response
    else
      git_response="n"
    fi

    if [[ "$git_response" =~ ^[Yy]$ ]]; then
      git init "$TOME_ROOT" >/dev/null
      echo "Initialized git repo in $TOME_ROOT"
    fi
  else
    echo "Git repo already exists in $TOME_ROOT"
  fi
else
  echo "Git is not installed. Skipping repo initialization."
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
